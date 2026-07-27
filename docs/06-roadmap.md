# 06 — Delivery Roadmap

A phased plan that gets you **legal and trading first**, then adds optimisation. Each phase
ships something usable; nothing is "big bang". Timeboxes are indicative — calibrate to team
size and the build-vs-buy decision ([doc 04 §9]).

## Phase 0 — Foundations & decisions (1–2 weeks)
- **Decisions to lock:** build vs buy fiscalization/e-SLOG ([doc 04 §9]); VAT-registered vs
  small-taxpayer mode; cost-flow method (FIFO/weighted-avg); hosting (EU region).
- Obtain **FURS digital certificate**; register **business premises & electronic devices**;
  draft the **internal act** ([doc 01 §3.2]).
- Engage the **accountant** to confirm rates, thresholds, chart of accounts, report formats.
- Stand up repo, CI, EU-hosted **MariaDB** (via the portable persistence layer — [doc 04 §2.1]), secrets manager, FURS **test** environment.
- **Security baseline from day one** (doc 05): TLS, encrypted PII, RBAC skeleton, audit table.

## Phase 1 — Compliant invoicing + fiscalization (MVP, ~4–6 weeks) ⭐
**Goal: issue a 100 %-legal, fiscally-verified invoice from a ticket.**
- Company/premises/device/rate config; user accounts with **tax numbers** + **passkeys/MFA**.
- Invoice object + Art. 82/83 **validation gate**; gapless **numbering** inside finalize txn.
- **Fiscalization service:** ZOI → EOR, QR/PDF417, **offline PENDING_EOR queue + two-working-day SLA**
  ([doc 01 §3], [doc 04 §4]).
- Payments (cash/card/transfer) deciding fiscalization; PDF + thermal receipt (reuse Smarty
  `printticket.tpl` styling + `$_language`).
- **Credit notes / storno** (append-only, references original).
- Immutable ledger + WORM archive; basic VAT books export.
- **Exit criteria:** counter can take a repair to a verified receipt; corrections work; nothing
  is editable post-finalize; passes a fiscalization contract test against FURS test env.

## Phase 2 — Inventory & technician warehouses (~4–6 weeks)
- Parts catalogue; multi-location stock; **StockMovement** as sole mutator.
- **Technician warehouses** + transfers + consumption-on-ticket + reconciliation report
  ([doc 02 §5]).
- Serialized/batch tracking; reservations; stocktake & adjustments with audit.
- Inventory **valuation** (cost incl. landed cost; FIFO/weighted-avg) feeding COGS.

## Phase 3 — Purchasing + EU VAT mechanics (~3–4 weeks)
- Purchase orders, goods receipt, 3-way match, supplier invoices.
- **VIES** validation; **intra-EU acquisition reverse charge**; import VAT/customs landed cost
  ([doc 01 §4]).
- Received-invoices VAT ledger; **RP-O**, **Art. 76.a** report (capability), **Intrastat
  threshold tracking + alert**.

## Phase 4 — Accounting standards & reporting (~3–4 weeks)
- **Posting-rule engine** + chart-of-accounts mapping; **journal export** to accountant
  ([doc 07]).
- Inventory valuation/NRV, COGS, receivables/payables ageing, doubtful-debt allowance.
- **DDV-O** + **VAT-ledger XML** exports in the eDavki schemas (mandatory since 1 Jul 2025); Art. 76.a (PD-O) capability; period lock/close; AJPES annual-report
  figures.
- Management dashboards (margin, utilization, turnaround, stock turnover).

## Phase 5 — Forecasting (~3–4 weeks)
- Consumption history rollups; reorder points; moving-average/exponential-smoothing demand;
  model-driven pre-positioning; suggested POs; dead-stock report; forecast-accuracy dashboard
  ([doc 02 §4]). Keep suggestions **explainable**.

## Phase 6 — e-invoicing & portal (~3–4 weeks, partly date-driven)
- **e-SLOG 2.0 / EN 16931** exporter; **UJP** delivery for **B2G now**; B2B behind a flag for
  the **2028 mandate** ([doc 01 §7]).
- Customer portal (status, estimate approval, invoices) with passkey/OTP auth ([doc 05 §7]).

## Phase 7 — Hardening & GDPR completion (ongoing, before scale)
- Full **DSAR/erasure** workflow + tiered retention job ([doc 05 §5]); RoPA, DPAs, DPIA.
- **Pen test** (focus: fiscalization + auth); SAST/DAST in CI; backup **restore drills**;
  breach-response tabletop.

---

## MVP cut (if you must ship the minimum legal thing first)
**Phase 0 + Phase 1 only**: configured company/premises/devices, passkey/MFA login, ticket →
validated invoice → **ZOI/EOR/QR** with the two-working-day offline fallback, credit notes, immutable
ledger + 10-year archive, basic VAT book. That is the smallest system that lets kron.si
**legally take money for a repair**. Everything else optimises operations on top of a compliant
core.

## Cross-cutting (every phase)
- Security & GDPR controls land **with** each feature, never after ([doc 05]).
- Each fiscal/tax assumption is **re-confirmed with the accountant** before that phase ships.
- Re-check the **FURS technical spec version** and **e-SLOG/EN 16931** at the start of any phase
  that touches them.

## Key risks & mitigations
| Risk | Mitigation |
|------|-----------|
| FURS spec changes / cert expiry | Version-pinned isolated service; expiry alerts; test env in CI. |
| Crash during finalize (print/EOR failures, double-submit) | Number allocation commits atomically with the invoice (rollback = counter also rolls back → structurally gapless); idempotent finalize + resend/reprint on recovery. |
| Two-working-day EOR window missed in an outage | Durable DB-backed queue, drained on recovery, SLA alerting. |
| Wrong VAT treatment (rates/reverse charge/margin) | Rates & rules as validity-dated config; accountant sign-off; VIES at source. |
| Tax retention vs GDPR erasure conflict | Tiered/field-level retention; statutory data preserved, rest erasable ([doc 05 §5.3]). |
| Build effort underestimated | Consider buying fiscalization/e-SLOG; phase ruthlessly; MVP first. |
| PII breach | Encryption, RBAC+RLS, audit, 72h response plan, pen test. |
