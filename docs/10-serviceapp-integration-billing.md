# 10 — ServiceApp Integration & Billing Migration

How the new ERP connects to your **existing ServiceApp** (the current ticketing/helpdesk
system) and pulls its **billing data** into compliant invoices.

> ⚠️ **I could not read the dump.** You pointed me at
> `/Users/urosvogrinec/servis/azet02_kayako.md` and `/Users/urosvogrinec/servis/SERVICEAPP_REFERENCE.md`.
> Those are on **your local Mac**; this session runs in an isolated cloud container that only
> has the git repo, so the files aren't reachable. **To finish the exact billing mapping, add
> them to the repo** (commit on this branch, or drop them in `docs/reference/`) or paste the
> schema. § 6 lists precisely what I need. Everything below is the integration design + a
> *provisional* mapping inferred from strong evidence (next paragraph).

## 1. What ServiceApp almost certainly is (evidence)

The repo's `printticket.tpl` is the tell:
- **Smarty `<{ ... }>` delimiters** and a **`$_language[...]`** string array — this is the
  signature of **Kayako "classic" (the SWIFT framework)**, a PHP/Smarty helpdesk. The dump name
  `azet02_kayako.md` confirms it: **ServiceApp is a Kayako-based system.**
- Slovenian ticket statuses (*Odprt | nalepka*, *Poslan v zunanji servis*), device/IMEI fields,
  external-service routing → it's been **customised into a device-repair workflow**.

So the integration is: **Kayako-classic schema → servmod ERP**. Kayako classic stores data in
MySQL/MariaDB with `sw*`-prefixed tables, which is convenient — same DB family as our chosen
store ([doc 04 §2]).

## 2. Provisional mapping (Kayako-classic → ERP) — verify against the dump

| Kayako (typical `sw*` tables) | Holds | → ERP entity ([doc 03]) |
|------------------------------|-------|--------------------------|
| `swtickets` | Ticket (subject, status, dept, owner, dates, custom fields) | **Ticket** |
| `swticketposts` | Ticket replies/notes (the repair narrative) | Ticket history / audit timeline |
| `swtickettimetracks` | **Time tracking: time worked vs. time billable, worker, workdate, billing notes** | **Billable labour lines** → invoice |
| `swticketnotes` | Internal notes | Ticket notes |
| `swusers`, `swuseremails`, `swuserorganizations` | Customers & companies (contact, org, VAT?) | **Customer** (+ company) 🔒 |
| `swcustomfieldvalues` / `swcustomfield*` | Device, IMEI/serial, model, warranty, **price/charge** custom fields | **Device**, charge lines, attributes |
| `swstaff` | Technicians/operators | **User** (needs **tax number** added for fiscal operator, [doc 01 §3.8]) |
| `swattachments` | Photos/docs of device | Device condition evidence ([doc 11]) |
| `swdepartments` | Departments / service lines | Service category / location mapping |
| (billing/charges custom tables, if added) | Parts charged, fees | **Invoice lines** (part/fee) |

**The billing crux:** in Kayako, chargeable work usually lives in **`swtickettimetracks`**
(billable minutes + worker + date + note) and/or **custom fields / a bolt-on charges table**.
Parts are often recorded as custom fields or free-text posts. So the ERP's job is to turn
*billable time + recorded parts/charges* per ticket into **structured invoice lines**
(labour vs. part vs. fee), apply **VAT** ([doc 01 §1]), and **fiscalize** ([doc 01 §3]).

## 3. Integration strategy — pick the relationship

| Option | ServiceApp role | ERP role | When |
|--------|-----------------|----------|------|
| **A. Full migration** | Retired | System of record for everything | If you intend to replace ServiceApp's ticketing too. |
| **B. Coexist + billing bridge** *(recommended start)* | Stays the ticketing front line | Pulls billable data, owns invoicing/stock/fiscal/accounting | Lowest disruption; technicians keep their familiar Kayako UI while billing modernises. |
| **C. Strangler migration** | Shrinks over time | Grows feature by feature ([doc 06] phases) | Migrate ticketing into servmod gradually, billing first. |

**Recommended: B → C.** Start with a **billing bridge** so you get compliant invoicing fast,
then migrate ticketing screens into the new glass UI ([doc 08]) phase by phase, with ServiceApp
as the fallback until parity.

### 3.1 The billing bridge (option B) — how it works
```
ServiceApp (Kayako, MariaDB)                      servmod ERP
  ticket closed / marked billable
        │  (1) read billable items
        ▼                                          (2) map → draft invoice lines
  swtickettimetracks (billable time) ─────────────►  labour lines (rate × time)
  custom fields / charges (parts, fees) ──────────►  part / fee lines (+ stock consumption)
  swusers/orgs ───────────────────────────────────►  Customer (matched/created, VAT-ID via VIES)
                                                     (3) operator picks payment method
                                                     (4) finalize → number + ZOI/EOR + PDF + e-SLOG
                                                     (5) write invoice id/EOR back to the ticket
```
- **Trigger:** a ticket reaching a "billable/closed" status (or a manual "Invoice this ticket"
  action) raises an event. Implement via (a) a **read-only DB view / connector** onto the
  Kayako DB, (b) Kayako's **API** if enabled, or (c) a small **sync worker** polling changed
  tickets. Prefer a **read-only** coupling to ServiceApp's DB to avoid corrupting it.
- **Idempotency & no double-billing:** each Kayako ticket/time-track row carries a
  `billed_invoice_id` mapping in the ERP; a ticket can't be invoiced twice ([doc 09 §2.3] same
  guard, with the `uninvoiced → invoiced → credited` status semantics).
- **Edited-after-billing detection (concrete mechanism):** the bridge's mapping table mirrors a
  `content_hash` + `updated_at` for every billed source row. A hash/timestamp change on an
  **already-billed** `swtickettimetracks` row (hours corrected after invoicing) raises a
  **"billed-then-edited" alert** requiring a manual credit note or supplemental invoice — never
  a silent re-sync. New time logged on a **reopened, already-invoiced ticket** automatically
  becomes a fresh uninvoiced BillableItem ([doc 09 §3]) — it is never merged into the old
  invoice.
- **Collective billing:** because Kayako time-tracks accumulate per ticket, the **collective
  invoice (zbirni račun, [doc 09])** is the natural monthly B2B document — sweep all billable
  tickets for a customer in the VAT period into one invoice.
- **Write-back:** push the resulting **invoice number + EOR + PDF link** back onto the Kayako
  ticket (a custom field/post) so staff see billing status where they already work.

## 3.2 Bidirectional coverage matrix — is *all* functionality to and from ServiceApp handled?

Every data flow between the two systems, direction by direction, with its mechanism and
status. ✅ = designed in this plan; 🔶 = designed but **needs the dump/skill to finalise field
mapping**; ⬜ = deliberately out of scope for the bridge (stays in one system).

**ServiceApp → ERP (reads):**

| Flow | Mechanism | Status |
|------|-----------|--------|
| Billable labour (time tracks) | read-only connector on `swtickettimetracks`; hash-mirrored | 🔶 field names from dump |
| Parts/fees charged on ticket | custom fields / bolt-on charges table → typed lines | 🔶 depends on customisation |
| Customers & organisations | match-or-create, dedupe by email/VAT ID, VIES check | 🔶 where VAT ID lives |
| Devices (model, IMEI/serial) | custom-field mapping → Device entity | 🔶 custom-field defs |
| Staff (technicians/operators) | `swstaff` → User; **tax numbers added in ERP** (not in Kayako) | ✅ |
| Ticket status transitions ("billable/closed") | event/poll trigger for the billing sweep | ✅ |
| Attachments (device photos) | referenced (not copied) unless migrating | ✅ |
| Reopened tickets / edited-after-billing rows | hash+timestamp guard (§3.1) | ✅ |
| Historical invoices (pre-ERP) | one-time import, read-only archival, **never re-fiscalized** | ✅ (§4) |

**ERP → ServiceApp (write-backs):**

| Flow | Mechanism | Status |
|------|-----------|--------|
| Invoice number + EOR + PDF link onto ticket | single custom field/post write (the **only** write the bridge makes) | ✅ |
| Billing status (uninvoiced/invoiced/credited) | same write-back channel | ✅ |
| Credit-note events (line credited → ticket flagged) | write-back note + status | ✅ |
| Estimate/approval links (if portal used) | posted as ticket note/URL | ✅ |
| Stock / parts availability into Kayako UI | ⬜ **not** written back — technicians use the ERP mobile view ([doc 02 §5.2]); mirroring stock into Kayako would create a second source of truth | ⬜ by design |
| Prices/catalogue into Kayako custom fields | ⬜ same reason — pricing resolves in the ERP at billing time ([doc 02 §3.6]) | ⬜ by design |

**Conflict & sync rules:** ServiceApp remains the **source of truth for ticket narrative**;
the ERP is the **source of truth for money, stock and fiscal documents**. The bridge is
**read-mostly** (one write-back channel), idempotent per source row, audited, and any
same-row conflict resolves in favour of the fiscal ledger (immutable) with an alert — never a
silent overwrite in either direction.

> **To close the 🔶 rows** I need the artefacts on your Mac — none are readable from this
> cloud session: `~/.claude/skills/serviceapp-complete/SKILL.md`,
> `/Users/urosvogrinec/servis/azet02_kayako.md`, and `SERVICEAPP_REFERENCE.md`. Commit them
> into this repo (suggested: `docs/reference/` + `.claude/skills/serviceapp-complete/`),
> paste them into chat, or teleport the session to your desktop (`claude --teleport`).

## 4. One-time historical migration

If/when you migrate (option A/C):
- **Extract** from the dump: customers/orgs, tickets, time tracks, custom fields, staff,
  attachments.
- **Transform:** normalise customers (dedupe by email/VAT ID), map custom fields → typed Device
  attributes, convert billable time → historical labour, map staff → users.
- **Load** into ERP master data. **Historical invoices already issued in ServiceApp are NOT
  re-fiscalized** — import them as **read-only archival records** (preserve original numbers,
  dates, ZOI/EOR if they exist) for the 10-year retention ([doc 01 §8]); only **new** invoices
  go through FURS.
- **Reconcile & validate:** counts, totals, spot-checks signed off before cut-over; run B and A
  in parallel briefly.
- **Charset:** ensure UTF-8 for Slovenian diacritics during ETL (Kayako classic was often
  `latin1`/`utf8` — watch for mojibake on č/š/ž).

## 5. GDPR & security for the integration ([doc 05])
- The bridge **moves personal data** → covered by the same encryption, RBAC, audit, and
  retention rules. Connector credentials in the secrets manager; **read-only** DB user on
  ServiceApp.
- Migration is a **processing activity** → add to the RoPA; pseudonymise where possible;
  don't copy data you won't use (minimisation).
- Audit every sync/migration batch (counts, source→target ids).

## 6. What I need from your dump to finalise this (please provide)
Add the files to the repo (e.g. `docs/reference/`) or paste the schema. Specifically:
1. **Schema (DDL):** the `sw*` tables, especially **`swtickettimetracks`** (column names/types
   for time worked, **billable** time, worker, workdate, billing notes) and **`swtickets`**.
2. **Custom-field definitions** (`swcustomfield*`) — which fields hold **device, IMEI/serial,
   model, warranty, parts, prices/charges**.
3. **Any billing/charges/parts tables** added on top of stock Kayako (the repair customisation).
4. **Customer/org tables** (`swusers`, `swuserorganizations`) — where **VAT ID / address** live.
5. **Staff table** (`swstaff`) — and whether **tax numbers** are stored (needed for fiscal
   operator, else we add them).
6. **Sample rows** for a couple of real billed tickets (anonymised is fine) so I can validate
   the labour/parts/fee line mapping end-to-end.
7. Whether the **Kayako API** is available/enabled, or if we should bridge at the **DB** level.

With those, I'll turn §2's provisional mapping into an exact field-by-field spec, write the
extract/transform queries, and define the billable-item → invoice-line rules precisely.

## 7. Acceptance checklist
- [ ] Confirm ServiceApp = Kayako-classic and the live DB engine/charset.
- [ ] Read-only connector or API to ServiceApp; secrets vaulted; audited.
- [ ] Billable-item extraction (time tracks + parts/fees) → typed invoice lines with VAT.
- [ ] Customer/org match-or-create with VIES VAT-ID validation.
- [ ] No double-billing (source-ref guard); invoice/EOR written back to the ticket.
- [ ] Collective (monthly zbirni račun) path for B2B tickets.
- [ ] Historical invoices imported read-only (not re-fiscalized); originals preserved 10y.
- [ ] UTF-8 ETL (Slovenian diacritics intact); reconciliation signed off.
- [ ] Migration added to RoPA; minimisation + audit.
