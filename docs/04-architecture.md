# 04 — Architecture & Integrations

How it's built, how it bolts onto the existing `servmod` app, and the integrations that carry
the compliance load. Concrete stacks are **recommendations**, chosen for compliance,
auditability and low operational risk — substitute equivalents the team knows well.

## 1. Context: what already exists

`servmod` today is a **Smarty-templated PHP-style ticketing app** (the repo's
`printticket.tpl` uses `<{...}>` Smarty delimiters, `$_ticketStatusTitle`,
`$_language[...]` i18n, Slovenian statuses like *"Poslan v zunanji servis"*, branding from
`kron.si`). The ERP **does not replace** the ticket UI; it adds the commercial/inventory/fiscal
backend and reuses the ticket as the spine ([doc 02 §1]).

**Integration seam:** expose the ERP as a service with a clean API; let the existing app call
it for estimates/invoices/stock, and reuse the Smarty layer + `$_language` dictionary for the
**print/PDF templates** so receipts keep the current look while gaining ZOI/EOR/QR blocks.

## 2. Recommended stack

| Concern | Choice | Why |
|---------|--------|-----|
| Primary DB | **MariaDB** (10.6 LTS+ / 11.x) on **InnoDB** | Team's choice; mature, transactional (ACID), free/open, great PHP support. Transactional integrity for numbering/ledger via `SELECT … FOR UPDATE`; append-only enforced via grants + triggers; JSON column type for snapshots; robust backup (mariabackup) + replication. |
| DB portability | **Pluggable persistence layer** (see §2.1) | The app must not hard-depend on MariaDB — keep a thin repository/ORM abstraction so PostgreSQL, MySQL, or another modern RDBMS can be swapped in. |
| Backend | A typed, well-supported framework (e.g. **PHP 8.x/Laravel** to match existing stack, *or* TypeScript/NestJS, *or* Go) | Match team skills; keep fiscal logic in a small isolated module regardless. Laravel/Doctrine/Prisma all abstract the DB cleanly. |
| Fiscalization service | **Isolated microservice** (own process, holds the cert) | Blast-radius isolation of the private key; independently testable against FURS test env. |
| Queue/jobs | **Durable queue** (DB-backed table, or Redis/RabbitMQ) | EOR retry, **scheduled & recurring invoices** ([doc 09](09-scheduled-collective-invoicing.md)), e-invoice dispatch, forecasting jobs. |
| Frontend | Server-rendered + progressive JS, mobile-first technician views | Counter speed + van use. |
| Cache | Redis (optional) | Catalogue, stock levels. |
| Object/WORM store | S3-compatible with **object-lock / immutability** | 10-year retention of PDFs/XML/fiscal payloads (doc 01 §8). |
| Frontend UI/UX | **Modern dark/light "Apple-glass" design system** | Full spec in [doc 08](08-ui-design-system.md). |

### 2.1 Database portability layer (MariaDB-first, not MariaDB-only)

MariaDB is the **primary** target, but the persistence layer is **pluggable** so another
modern RDBMS (PostgreSQL, MySQL, etc.) can be substituted with config, not a rewrite:

- **Access only through a repository / ORM abstraction** (Eloquent + query builder, or
  Doctrine DBAL, or Prisma). No raw vendor-specific SQL in business code; vendor-specific bits
  live behind a `DatabaseDriver` interface.
- **Stick to portable types & features:** `DECIMAL` for money (never float), `DATETIME`/UTC,
  standard constraints/foreign keys, `JSON` columns (supported by MariaDB, MySQL, PostgreSQL).
- **Migrations are vendor-neutral** (framework migration files), with a per-driver hook for the
  few divergent pieces (see below).
- **Where engines differ, abstract it:**
  - *Append-only enforcement* — Postgres can `REVOKE UPDATE/DELETE`; **MariaDB uses
    `BEFORE UPDATE`/`BEFORE DELETE` triggers that `SIGNAL SQLSTATE` on the ledger tables**, plus
    a restricted app DB user. Same guarantee, driver-specific implementation ([doc 03 §6]).
  - *Row scoping* — Postgres has native RLS; **MariaDB enforces scoping in the app/service
    layer + scoped views** ([doc 05 §2]). The security guarantee is identical; only the
    enforcement point moves.
  - *Sequences/numbering* — both use a transactional counter row with `SELECT … FOR UPDATE`
    inside the finalize transaction ([doc 03 §6]); avoid `AUTO_INCREMENT` for fiscal numbers.
- **CI runs the test suite against MariaDB (primary) and at least one alternate** to keep the
  abstraction honest.

## 3. Service decomposition

```
                 ┌──────────────────────────────────────────────┐
                 │            servmod (existing UI/tickets)        │
                 └───────────────┬────────────────────────────────┘
                                 │  internal API (authn'd)
        ┌────────────────────────┼─────────────────────────────────────────┐
        ▼                        ▼                       ▼                   ▼
  Sales/Invoicing         Inventory/Purchasing      Reporting/Export    Auth/Identity
  (invoices, credit         (parts, stock,            (VAT books,        (passkeys/2FA,
   notes, payments,          locations incl.           DDV-O/RP-O,        RBAC, audit)
   numbering, ledger)        technician whs, PO,       Intrastat,         [doc 05]
        │                    forecasting)              e-SLOG, journal)
        │
        ▼
  ┌───────────────┐   signs w/ FURS cert, computes ZOI, gets EOR
  │ Fiscalization │ ───────────────►  FURS web service (TLS-mutual, XML/JSON)
  │  microservice │ ◄───────────────  EOR / errors
  └──────┬────────┘
         │ durable queue (PENDING_EOR), worker drains, ≤48h SLA + alerting
         ▼
   MariaDB (immutable ledger)  +  WORM archive (PDF/XML/payloads)
```

All services share the MariaDB immutable ledger but only the **Sales** service may INSERT
invoices; the DB role enforces no-UPDATE/DELETE on ledger tables ([doc 03 §6]).

## 4. The FURS fiscalization microservice (the compliance heart) — [doc 01 §3]

Responsibilities:
1. **Hold the FURS digital certificate** (private key in a secrets manager / HSM-backed store;
   never in app DB or repo). Rotate; alert ≥30 days before expiry.
2. **Compute ZOI** locally: build the canonical string (tax no., issue datetime, invoice no.,
   premises, device, total) → **RSA-SHA256 sign** → **MD5** → 32-hex.
3. **Build & send** the verification message to FURS (SOAP/XML or JSON per current spec) over
   **mutually-authenticated TLS**, message signed with the cert; parse **EOR**.
4. **Generate the QR/PDF417/Code128 payload** (ZOI+tax no.+timestamp+check digit).
5. **Offline/ retry path:** if FURS unreachable, return ZOI-only, mark `PENDING_EOR`, enqueue;
   a worker retries with backoff; **hard alert** as the 48h window approaches; record EOR &
   reprint on success.
6. **Idempotency:** keyed by (premises, device, number) — a crash-retry never double-submits or
   re-numbers.
7. **Test mode:** point at the **FURS test endpoint** with test certs for CI/e2e.

> Keep this service tiny, heavily tested, and version-pinned to the **current FURS technical
> documentation** (re-check on each FURS release; the spec is versioned, currently ≈ v3.1).

## 5. e-invoicing (e-SLOG / EN 16931) — [doc 01 §7]

- An **invoice-rendering layer** turns the internal invoice object into:
  PDF, fiscal payload, **e-SLOG 2.0 XML** (with SI national extensions), **EN 16931** UBL/CII.
- **B2G:** deliver e-SLOG via **UJP** today (when invoicing public bodies).
- **B2B:** build the exporter now; the **2028 mandate** becomes a feature flag + a delivery
  channel (access point / the SI exchange route as finalized in the ZEPDESED implementing
  rules). Validate against EN 16931 schematron.

## 6. External integrations

| Integration | Purpose | Notes |
|-------------|---------|-------|
| **FURS** fiscal verification | ZOI/EOR | §4; cert-based. |
| **FURS eDavki** | VAT return/ledger submission | Match e-VAT formats (doc 01 §8). |
| **UJP** | B2G e-invoice delivery | e-SLOG. |
| **VIES** | Validate EU supplier/customer VAT IDs | At PO and B2B invoicing (doc 01 §4.2). |
| **Banka Slovenije/ECB** | FX reference rates | Non-EUR invoices. |
| **Accounting software** | Journal/ledger export | Standard interchange + posting file (doc 07). |
| **Payment/card terminal** | Cash/card split | Optional, for reconciliation. |
| **AJPES** | Annual report filing data | Export to support filing (doc 07). |
| **Supplier catalogues/EDI** | Part pricing, PO/ASN | Optional; speeds purchasing. |
| **Email/SMS** | Customer notifications, portal links | Consent-aware (doc 05). |
| **Barcode/label & scanners** | Parts, tickets (existing barcode use in template) | Reuse current Code128 approach. |

## 7. Environments, deploy, observability

- **Environments:** dev → **FURS-test-backed staging** → prod. Never test against the live
  FURS endpoint.
- **Data residency:** host in the **EU** (GDPR, doc 05). Slovenian/EU cloud or on-prem.
- **CI/CD:** automated tests incl. a **fiscalization contract test** against FURS test certs;
  schema migrations reviewed; no secrets in repo.
- **Observability:** structured logs (PII-redacted), metrics on EOR latency & PENDING_EOR
  backlog, alerts on the 48h SLA, cert expiry, queue depth, failed VIES, period-close status.
- **Backups & DR:** point-in-time recovery (MariaDB binlog + `mariabackup`), immutable archive replication, tested restores —
  see [doc 05 §backups].

## 8. Performance & concurrency notes

- Number allocation is the main contention point → per-(premises,device) sequence, short
  transactions, no user think-time inside the txn.
- Stock levels are hot → movements append + materialized `StockLevel` with row locking on the
  affected `(part, location)` only.
- Forecasting and reporting run as **off-peak batch jobs**; never block the counter.

## 9. Build vs. buy (be honest about effort)

The fiscalization + VAT + e-SLOG surface is large. Options:
- **Buy the fiscalization piece** (a certified SI fiscal/e-invoice provider exposes ZOI/EOR &
  e-SLOG via API) and **build** the repair-specific ERP (tickets, parts, technician
  warehouses, forecasting) — **recommended**: lowest compliance risk, fastest to market.
- **Build fiscalization in-house** against the FURS spec (the algorithm is well-documented;
  reference implementations exist) — more control, more ongoing maintenance as the spec
  evolves. Keep it isolated (§4) either way.

Decide this early — it shapes the roadmap (doc 06).
