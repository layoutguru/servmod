# 03 — Data Model

Entities and the invariants that make the system compliant. Notation is database-agnostic
(targets **MariaDB / InnoDB** as the primary store, with a portable abstraction for other
RDBMS — [doc 04 §2.1]). PII columns are marked 🔒 and
are encrypted/access-controlled per [doc 05](05-security-gdpr.md).

## 1. Entity map (high level)

```
Company ──< BusinessPremises ──< ElectronicDevice
Company ──< TaxRate (validity-dated)
User(operator) ──< Role; User has tax_number 🔒
Customer 🔒 ──< Device ──< Ticket ──< TicketLine(labour) / PartConsumption
Ticket ──< Estimate ──< Invoice ──< InvoiceLine
Invoice ──< Payment
Invoice ──< CreditNote (references Invoice)
Invoice ──1:1── FiscalRecord (ZOI/EOR)         [cash invoices]
Part ──< StockLevel(per Location) ; Part ──< SupplierPart
PurchaseOrder ──< POLine ; GoodsReceipt ──< GRLine
StockMovement (the ONLY mutator of stock)
Supplier 🔒(VAT id) ; Location (incl. per-technician)
AuditEvent (append-only)   [the "immutable fiscal ledger" = the finalized, append-only
                            Invoice/CreditNote/FiscalRecord rows — not a separate table]
```

## 2. Configuration & fiscal setup

**Company**: legal name, address, `vat_id` (SIxxxxxxxx), `tax_number`, `is_vat_registered`
(bool — supports small-taxpayer mode), default currency, fiscal cert reference, accounting
chart mapping ref.

**BusinessPremises**: `bp_id_label` (the FURS premises ID you registered), type
(`immovable`/`movable`), cadastral data (for immovable), address, `registered_at`.
**Immutable once invoices exist against it.**

**ElectronicDevice**: `device_id_label`, belongs to a premises, description. Together
(premises + device) own a **number sequence**.

**TaxRate**: `code` (S/R1/R2/Z/E/AE/R), `percent`, `valid_from`, `valid_to`, `legend_text`
(printed for exemption/reverse/margin). Never deleted — superseded by date.

**NumberSequence**: keyed by the **numbering mode chosen in the internal act** ([doc 01 §3.3],
ZDavPR Art. 5): mode (a) per business premises → `(premises_id, series, [year])`; mode (b) per
electronic device → `(premises_id, device_id, series, [year])`. The `year` component is
present only when `reset_policy = annual` (vs `continuous`) — both the mode and the reset
policy are company/series config, so **both legal choices are representable**. Allocation is
atomic (see §6). Series also exist for non-cash invoices, credit notes, estimates, POs.

## 3. People & parties

**User**: id, name, login identity, `tax_number` 🔒 (required to finalize cash invoices —
becomes the fiscal *operator*), status, roles, WebAuthn credentials (doc 05), TOTP secret 🔒.

**Customer** 🔒: type (natural/legal), name, address, `vat_id` (nullable; required for B2B
deduction), `tax_number` (legal), email/phone 🔒, marketing-consent flags + timestamps,
`gdpr_retention_until`, notes. **Invoices snapshot customer data** (see §5) so later edits to
the customer record never mutate an issued invoice.

**Supplier** 🔒: name, address, `vat_id`, country, `is_eu`, VIES last-validated-at, payment
terms, default currency.

**Device** (the thing repaired): owner=Customer, type/brand/model, `serial`/`IMEI` 🔒,
accessories, condition-in notes, photos.

## 4. Tickets, estimates, stock-on-job

**Ticket**: number, customer, device, status (state machine — doc 02 §1, including
`ready_uncollected` → `disposed`/`sold`/`scrapped` for abandoned devices, and
`advance_refunded`), assigned technician, intake notes, fault, diagnosis, warranty flag +
warranty payer, timestamps, consent record ref, storage-fee accrual ref (uncollected devices),
notice log (formal abandoned-goods notices sent).

**Estimate**: number (non-tax series), ticket, lines, totals, status (draft/sent/approved/
declined), approval record (who/when/how 🔒 ip).

**TicketLine (labour)**: description, hours, rate, vat_rate_ref, net/vat/gross.

**PartConsumption**: ticket, part, location (the technician/shop it came from), qty, the
**StockMovement** it created, cost-at-consumption (for COGS), the invoice line it bills to.

## 5. Sales documents (the immutable core)

**Invoice** (append-only after finalize):
- `id`, `number` (allocated at finalize), `series`, `type` (full/simplified/advance),
- `status` (draft → finalized → [corrected]),
- `premises_id`, `device_id`, `operator_user_id` (+ operator tax_number snapshot 🔒),
- `customer_snapshot` (JSON: name/address/vat_id at issue) 🔒,
- `warranty_payer_snapshot` (nullable),
- `issue_datetime`, `supply_date`, `due_date`,
- `expected_payment_methods` (informational; **fiscalization is derived from actual
  `Payment` rows — any cash-type payment ⇒ fiscalize**, [doc 01 §3.1]),
- `origin` (manual/scheduled/recurring/collective), `recurring_profile_id` (nullable),
  `period_start`/`period_end` (collective),
- `currency`, `fx_rate` (+ EUR equivalents if non-EUR),
- totals per VAT-rate group (`net`, `vat`, `gross`), grand totals,
- `legends` (reverse charge / margin / exemption / small-taxpayer text),
- `is_fiscalized` (bool), `fiscal_record_id` (nullable),
- `corrected_by_creditnote_id` (nullable), `replaces_invoice_id` (nullable),
- `content_hash` (SHA-256 over canonical serialization → tamper-evidence, doc 05).

**InvoiceLine**: invoice, seq, `line_type` (labour/part/part_margin/accessory/fee/discount/
advance_deduction/weee/reverse_charge), description, qty, unit, unit_price_net, discount,
`vat_rate_ref` (the rate **as of supply_date**), `price_list_ref` (resolved price snapshot),
net, vat, gross (line VAT distributed from the rate-group total by largest remainder,
[doc 01 §2.2]), `margin_cost` (for margin-scheme lines), `source_ref` (part_id /
ticket_line_id / delivery) with a **uniqueness guard**: a source item is `uninvoiced` →
`invoiced` (atomic at finalize) → `credited` (when a credit-note line references the same
`source_ref`; re-billing after crediting is a deliberate, audited action, never automatic —
[doc 09 §2.3]).

**Payment**: invoice, amount, method, datetime, operator, (card auth ref), `cash_session_id`
(for cash-type payments).

**CashSession** (drawer management, [doc 02 §2.4]): premises, operator, `opened_at`/`closed_at`,
`opening_float`, `closing_counted`, `computed_expected`, `variance` + explanation, status.
**CashMovement**: session, direction (in/out), amount, reason, ref, operator, datetime.
The daily **Z-report** is a generated document referencing the session and its fiscal receipts.

**CreditNote / DebitNote**: own number/series, `original_invoice_id` (**required**), reason
code, lines (full/partial), totals, `is_fiscalized`, `fiscal_record_id`, `content_hash`.
Modeled as an Invoice subtype with `sign = -1` to keep one ledger.

**FiscalRecord** (1:1 with a fiscalized document — [doc 01 §3]):
- `zoi` (32 hex), `eor` (nullable until verified), `qr_payload`,
- `operator_tax_number` 🔒, `issue_datetime`, premises/device/number echo,
- `verification_status` (`PENDING_EOR` / `VERIFIED` / `FAILED`),
- `submitted_at`, `verified_at`, `attempts`, `last_error`,
- `protocol` (real-time vs subsequent ≤2 working days, [doc 01 §3.6]), `message_id`.

## 6. Numbering & immutability invariants (critical)

1. **Gapless, ascending** within the internal-act-chosen numbering unit (§2 NumberSequence —
   per premises or per device, annual or continuous). Allocate `next_value` with
   `SELECT ... FOR UPDATE` then `UPDATE` **inside the same transaction** that inserts the
   finalized invoice (note: MariaDB supports `RETURNING` on `INSERT`/`REPLACE`/`DELETE` but
   **not** on `UPDATE` — read the locked value first or track it in the app). Because the
   counter increment and the invoice insert commit **in the same transaction**, a rollback or
   crash reverts both — **gaps are structurally impossible**, not merely mitigated. The only
   crash window is *after* commit (print/EOR/send failures): recovery is **idempotent
   re-processing** of the already-committed invoice (resend to FURS keyed by premises/device/
   number, reprint), never re-allocation. Document this guarantee in the internal act.
2. **No edit, no delete** of finalized invoices/credit notes/fiscal records — enforced at the
   DB **and** app layer. On **MariaDB**: a restricted app DB user **without** UPDATE/DELETE
   grants on the ledger tables, **plus** `BEFORE UPDATE`/`BEFORE DELETE` triggers that
   `SIGNAL SQLSTATE '45000'`. This blocks tampering **by the application role**; it does NOT
   stop a connection holding TRIGGER/SUPER/root privileges (which can drop the trigger or
   re-grant itself rights). That DBA-level threat is countered *outside* the engine: external
   hash-chain checkpoints to the WORM archive (§6.3), DB audit-log shipping to a separate
   trust domain, and strict separation of who holds DBA credentials. (On PostgreSQL the
   equivalent baseline is `REVOKE` + rules — [doc 04 §2.1].)
3. **content_hash chaining (required):** each ledger row stores the hash of the previous
   finalized document. Detection only works with an **external anchor**: the chain head is
   checkpointed on every finalize (or at least daily) to the **WORM/object-lock archive**
   ([doc 01 §8]) — optionally RFC 3161-timestamped — and a **scheduled verification job**
   recomputes the chain and compares against the anchored checkpoints. Without the external
   anchor the chain only protects against accidental corruption and unprivileged tampering,
   not a malicious DBA (who could regenerate a self-consistent chain).
4. **No back-dating into a closed VAT period.** `issue_datetime` validated against period locks.
5. **PENDING_EOR is a valid issued state** — the document exists with ZOI; EOR fills in later.

## 7. Inventory

**Part**: SKU, names (per-locale SL/EN/DE, [doc 08 §8]), oem/aftermarket numbers, compatible
models (M:N to device models), `vat_rate_ref`, default cost, default price, `is_serialized`,
`is_hazardous`/WEEE, min/max/reorder point, lead_time_days, supplier warranty days, status.

**PriceList** ([doc 02 §3.6]): scope (default/shop/customer/contract), `valid_from`/`valid_to`,
status. **PriceListEntry**: price list, part-or-service, price, discount %. Resolution:
customer/contract → shop → default; the resolved price is snapshotted on the invoice line.

**Location**: id, type (`central`/`shop`/`technician`/`virtual`), name, owner_user_id (for
technician warehouses), premises_id.

**StockLevel**: `(part_id, location_id)` → `qty_on_hand`, `qty_reserved`. Derived from movements
(materialized for speed; the movements are the source of truth).

**StockMovement** (append-only — the **only** mutator of stock):
- type (receipt/transfer/consumption/return/adjustment/writeoff),
- part, qty (signed), from_location, to_location, ref (PO/GR/ticket/stocktake),
- unit_cost (for valuation), serial (if serialized), reason, operator, datetime.

**SerialUnit** (for serialized parts): serial, part, current_location/installed_in_device,
status, cost, warranty_until.

## 8. Purchasing

**PurchaseOrder**: number, supplier, currency, status, lines, expected_date,
`acquisition_type` (domestic/eu_acquisition/import) → drives VAT (doc 01 §4).
**POLine**: part, qty, unit_cost, vat treatment.
**GoodsReceipt** + **GRLine**: against PO, qty received, landed cost components (freight, duty,
import VAT), creates receipt StockMovements.
**SupplierInvoice**: matched to PO/GR (3-way), posts to received-invoices VAT ledger,
reverse-charge entries for EU acquisitions, MRN/import data for imports.
**SupplierCreditNote** ([doc 02 §3.5]): references the original SupplierInvoice/GoodsReceipt,
lines, reason, input-VAT correction (received-invoices ledger, period of issue), linked
return-to-supplier StockMovement; adjusts landed cost/valuation.

## 9. Forecasting (derived/analytic)

**ConsumptionHistory** (rollup from StockMovements of type consumption): part, period, qty,
location, device_model. **ForecastSuggestion**: part, suggested_qty, reorder_by_date, basis
(explainable inputs), status (suggested/accepted→PO/dismissed).

## 10. Tax & reporting registers (generated, but persisted for audit)

**VatLedgerEntry** (issued/received), **MarginSchemeRegister** (purchase cost, sale, margin,
VAT-on-margin per unit), **ReverseCharge76aEntry**, **IntrastatMovement** (arrivals/dispatches
cumulative), **RecapitulativeEntry** (RP-O). These are reproducible from source documents but
snapshotted per filing period and **locked** when a period is filed.

## 11. Audit & security tables (see doc 05)

**AuditEvent** (append-only): actor, action, entity, before/after (redacted for PII), ip,
device, datetime, request_id. **AuthEvent**: logins, MFA, passkey registration/use, failures.
**ConsentRecord**: subject, purpose, granted/withdrawn, timestamp, evidence.
**DataRequest**: DSAR/erasure requests, status, fulfilment export ref.

## 12. Period locking & closing

**AccountingPeriod**: month/quarter, status (open/locked/filed). Locking blocks new documents
dated into it and freezes the derived registers; reopening is a privileged, audited action.
