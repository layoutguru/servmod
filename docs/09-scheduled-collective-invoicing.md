# 09 — Scheduled, Recurring & Collective Invoices (zbirni/skupni račun)

Three related-but-distinct capabilities the business asked for, plus their **Slovenian legal
basis** and how they interact with **fiscal verification** ([doc 01 §3]). As ever: engineering
interpretation — **confirm with the accountant.**

| Capability | What it is | SL term |
|------------|-----------|---------|
| **Scheduled invoice** | A drafted invoice issued automatically at a chosen future date/time. | *načrtovani / odloženi račun* |
| **Recurring invoice** | A template that auto-generates invoices on a repeating schedule (e.g. monthly maintenance contract). | *ponavljajoči se račun* |
| **Collective invoice** | One invoice consolidating **many supplies/tickets** over a period into multiple lines. | **zbirni / skupni račun** |

These overlap: a common case is a **recurring + collective** monthly invoice — "on the 1st of
each month, bill customer X for all repairs completed last month as one multi-line invoice."

---

## 1. Legal basis & constraints (ZDDV-1)

- **Collective invoice (skupni/zbirni račun)** is explicitly allowed: a taxable person who makes
  **several separate supplies** of goods/services may issue **one invoice covering them**,
  **provided the VAT on all the listed supplies becomes chargeable within the same tax period**
  (the tax period in SI is typically the **calendar month**). → *A collective invoice must not
  straddle two VAT periods.* (ZDDV-1 invoicing rules, Art. 81 et seq.)
- **Invoice-issue deadline:** an invoice must be issued in time for the correct VAT period; for
  certain cross-border/Art. 196 cases the deadline is **the 15th of the month following** the
  taxable event. For domestic B2C cash repairs the invoice is issued **at the moment of
  supply/payment** (and fiscalized) — so *scheduling* mostly applies to **B2B / bank-transfer**
  invoices and to **periodic contracts**, not to walk-in cash sales.
- **Each supply keeps its own tax point.** On a collective invoice every line still references
  its **supply/completion date**; the VAT is accounted in the period of chargeability. The
  engine must validate that all lines on one collective invoice fall in the **same VAT period**
  ([doc 03 §12] period locks).
- **Numbering & content** rules are unchanged ([doc 01 §2, §5]): a scheduled/recurring/
  collective invoice is a normal invoice — full Art. 82 content, gapless numbering allocated
  **at the moment it is actually finalized/issued** (not when scheduled).

### 1.1 Fiscal verification implications ⭐ (critical)
- **The 48h / ZOI-EOR machinery is unchanged** ([doc 01 §3]). A scheduled invoice is only
  **fiscalized at the instant it is finalized**, using **that moment's** timestamp for the ZOI,
  and obtains its EOR then.
- **Cash + scheduling is a contradiction** for fiscal law (cash invoices are verified at the
  point of the cash transaction). → **Scheduled/recurring invoices are intended for
  non-cash (bank-transfer) payment**, which is **not** subject to fiscal verification. The UI
  must **prevent scheduling a cash-payment invoice** (or, if a future cash invoice is modelled,
  it stays a *draft* and is only fiscalized when the cash is actually taken). Make this a
  hard rule, configurable but defaulting to "scheduled ⇒ non-cash".
- A scheduled invoice that **does** require fiscalization (configured edge case) goes through
  the normal real-time → PENDING_EOR path at finalize time, with the same 48h guarantee.

---

## 2. Functional design

### 2.1 Scheduled (deferred) invoice
- Build the invoice as a **draft**, set **`scheduled_issue_at`** (date/time, timezone-aware).
- A scheduler picks it up at that time → runs the **same finalize pipeline** as a manual issue
  ([doc 02 §2.3]): validation gate → number allocation → snapshot → (fiscalize if applicable) →
  PDF/e-SLOG → ledger → optional auto-send (email/portal) in the **document's locale**
  ([doc 08 §11]).
- Pre-issue editable; after issue, immutable (corrections via credit note).
- Failure handling: if the validation gate fails at issue time (e.g. missing VAT ID), it
  **does not silently issue** — it flags the document and alerts a user; never produces a
  non-compliant invoice.

### 2.2 Recurring invoice (template + schedule)
- **RecurringInvoiceProfile**: a template (customer, default lines, payment terms, language,
  VAT treatment) + a **schedule** (RRULE-style: daily/weekly/monthly/quarterly/yearly, day-of-
  month, end date or occurrence count, next-run).
- On each run the scheduler **materialises a draft** from the template, optionally **pulls in
  the period's open items** (making it *recurring + collective*, §2.3), then issues it (per
  §2.1). 
- Profile management: pause/resume, skip next, edit template (affects future runs only),
  proration rules, price-list updates, auto-stop at end date.
- Use cases for a repair business: **maintenance/SLA contracts**, managed-device fleets,
  retainer customers, periodic consumables.

### 2.3 Collective invoice (zbirni / skupni račun)
- **Aggregates many source items** — completed tickets / deliveries / consumed parts / labour
  for **one customer within one VAT period** — into a **single multi-line invoice**.
- Two ways to build it:
  1. **Manual:** "Create collective invoice" → pick customer + period → the system lists all
     **uninvoiced billable items** ([doc 02 §1]) in that period → select/deselect → generate.
  2. **Automatic (recurring + collective):** a recurring profile runs at period-end and sweeps
     all uninvoiced items for the customer into one invoice.
- **Line grouping options (configurable):** one line per ticket, per part+labour, per day, or
  fully itemised; each line keeps a **back-reference** to its source ticket/movement
  ([doc 03 §5]) for traceability and so an item can't be **double-invoiced** (mark source
  `invoiced` atomically at finalize).
- **VAT-period guard:** the builder only offers items whose chargeability is in the **same tax
  period** and **blocks** mixing periods (§1).
- **Per-rate subtotals:** with many lines across rates, the document shows correct **per-VAT-
  rate net/VAT/gross subtotals** ([doc 01 §2]).
- Interacts cleanly with **advances** ([doc 02 §2.2]) and **credit notes** (a correction to one
  line → credit note referencing this collective invoice).

---

## 3. Data model additions ([doc 03])

- **RecurringInvoiceProfile**: id, customer, template lines (JSON or child rows), payment
  method (default non-cash), `language`, schedule (`rrule`, `next_run_at`, `end_at`/`count`),
  `collective` flag + sweep criteria, status (active/paused/ended), audit.
- **ScheduledInvoiceJob**: links a draft invoice (or a profile occurrence) to `scheduled_
  issue_at`, status (pending/issued/failed/skipped), attempts, last_error, resulting
  `invoice_id`.
- **Invoice** gains: `origin` (`manual` / `scheduled` / `recurring` / `collective`),
  `recurring_profile_id` (nullable), `period_start`/`period_end` (for collective), and lines
  gain `source_ref` (ticket/movement/delivery) with a **uniqueness guard** preventing
  re-invoicing.
- **BillableItem view**: uninvoiced labour/parts/deliveries per customer per period (drives the
  collective builder and the dashboards).

---

## 4. Scheduler / architecture ([doc 04])

- A **durable, DB-backed scheduler** (a `due_jobs` table + a worker; or framework scheduler
  e.g. Laravel Scheduler + queue) — **not** cron-fire-and-forget, because issuing an invoice is
  a financial event needing **idempotency, retries, audit, and crash-safety**.
- **Idempotency:** each occurrence keyed by `(profile_id, period)` so a worker restart never
  double-issues. The finalize transaction (number allocation + ledger insert) is the atomic
  boundary ([doc 03 §6]).
- **Timezone:** schedules evaluated in **Europe/Ljubljana**; stored as UTC.
- **Observability:** dashboard of upcoming/failed scheduled jobs; alerts on failures and on a
  scheduled job that would cross a VAT-period boundary or hit a validation error.
- **Backend-configurable** ([doc 08 §10]): default grouping, default language, cut-off day for
  period sweeps, whether scheduling cash invoices is permitted (default **no**, §1.1),
  retry policy, auto-send on/off and the per-locale email template.

---

## 5. UX ([doc 08])

- **Schedule builder** widget: pick frequency, day, end condition, preview the next N issue
  dates, preview the draft.
- **Collective builder**: customer + period picker → checklist of billable items with running
  totals and **per-rate subtotal preview** → one-click generate.
- **Recurring profiles list**: status, next run, last issued, quick pause/skip, health (failed
  runs highlighted in `--state-danger`).
- All localised SL/EN/DE; document language selectable per profile/invoice; printouts localised
  ([doc 08 §11]).

---

## 6. Acceptance checklist
- [ ] Collective invoice enforces **single VAT period**; per-rate subtotals correct.
- [ ] Source items back-referenced and **cannot be double-invoiced** (atomic mark at finalize).
- [ ] Scheduled/recurring default to **non-cash**; cash-scheduling blocked unless explicitly configured.
- [ ] Fiscalization (if applicable) happens **at finalize time** with that timestamp's ZOI/EOR + 48h fallback.
- [ ] Numbering allocated at issue, gapless ([doc 03 §6]); scheduled drafts hold **no** number.
- [ ] Durable, idempotent, crash-safe scheduler; Europe/Ljubljana schedules; audit + failure alerts.
- [ ] Recurring profiles: pause/skip/end, edit affects future only, optional period sweep (recurring+collective).
- [ ] Validation gate blocks auto-issue of a non-compliant invoice (alerts instead).
- [ ] Fully backend-configurable (grouping, language, cut-off, retries, auto-send templates per locale).

## Sources
- ZDDV-1, 81. člen (obveznost in rok izdaje računov / collective & periodic invoices): https://www.racunovodstvo.net/zakonodaja/zddv/81-clen
- ZDDV-1, 84. člen (papirnati in elektronski računi): https://www.racunovodstvo.net/zakonodaja/zddv/84-clen
- FURS — DDV / računi (podrobnejši opis): https://www.fu.gov.si/fileadmin/Internet/Davki_in_druge_dajatve/Podrocja/Davek_na_dodano_vrednost/Opis/Racuni.doc
- E-računovodstvo — *Izdajanje računov (81.–84. člen ZDDV-1)*: https://www.eracunovodstvo.org/blog/racunovodstvo/izdajanje-racunov-81-do-84-clen-zakona-o-davku-na-dodano-vrednost-zddv-1/
