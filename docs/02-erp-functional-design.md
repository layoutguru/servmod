# 02 — ERP Functional Design

How the repair business actually flows, and which legal documents ([doc 01](01-legal-compliance-slovenia.md))
each step produces. The existing `servmod` Smarty app already owns the **service ticket**;
this ERP wraps commercial + inventory + fiscal logic around it.

## 0. Domain glossary (Slovenian ↔ system)

| SL | EN / system term |
|----|------------------|
| Servisni nalog / ticket | Service ticket / repair order |
| Predračun / ponudba | Cost estimate / quotation (non-tax) |
| Avansni račun | Advance invoice (tax) |
| Račun | Invoice |
| Dobropis / bremepis | Credit note / debit note |
| Storno | Cancellation |
| Skladišče | Warehouse / stock location |
| Naročilnica | Purchase order (to supplier) |
| Prevzem | Goods receipt |
| Nadomestni del | Spare part |
| Poslovni prostor / elektronska naprava | Business premises / electronic device (fiscal) |

---

## 1. The core repair → cash lifecycle

```
Customer & device intake
        │  (servmod ticket created; device, fault, IMEI/serial, accessories)
        ▼
Diagnosis ──► Estimate (predračun)  ──► Customer approval (timestamped/e-signed)
        │                                        │
        │                                  declines → diagnostic-fee invoice (if charged,
        │                                  own small invoice, fiscalized per payment method;
        │                                  or explicit waive) → advance refunded via credit
        │                                  note if one was taken → return device, close
        ▼
Parts reservation ──► (parts in stock? ) ──► if not: Purchase Order → Goods receipt
        ▼
Repair work (labour logged, parts consumed from a stock location)
        ▼
Quality check ──► Ready for pickup (customer notified)
        ▼
Invoice issued  ──► payment method?
        │              ├─ cash/card/cheque → FURS fiscal verification (ZOI+EOR+QR)  [doc 01 §3]
        │              └─ bank transfer    → normal invoice (no fiscalization)
        ▼
Payment recorded ──► device handed over ──► repair warranty starts
        ▼
(Later) return/complaint → Credit note (dobropis), itself fiscalized if cash refund

Not collected? Ready-for-pickup ──(configurable clock)──► ready_uncollected
        ├─ periodic storage-fee lines (configurable, announced in T&Cs at intake)
        ├─ formal notice(s) to customer (documented, per abandoned-goods rules)
        └─ terminal: disposed (WEEE write-off) / sold to recover costs / scrapped
```

Each transition is a **state**, each state change is **audit-logged** (doc 05), and the
ticket is the spine that links device → parts consumed → labour → invoice → warranty → any
later credit note.

---

## 2. Sales documents

### 2.1 Estimate / quotation (predračun) — non-tax
- Not fiscalized, not in the VAT ledger. Own numbering series.
- Lines: labour (estimated hours × rate), anticipated parts (catalogue price), diagnostic fee.
- Customer **approval** is captured (portal link / in-shop signature) with timestamp, IP/device,
  and the approving person → this is the consumer-consent record (doc 01 §9).
- Converts in one click into the work order and, later, the invoice (carrying lines forward).

### 2.2 Advance invoice (avansni račun) — tax
- Issued when a deposit is taken before completion. VAT becomes chargeable on the advance.
- If paid in cash/card → **fiscalized**.
- On final invoice, the advance is **deducted** with a reference line; net cash collected at
  the end matches.
- **Advance refund (repair declined / device unrepairable):** a credit note is issued
  **against the advance invoice itself** (not against any final invoice), fiscalized if the
  refund is paid out in cash; the ticket closes with status `advance_refunded`.

### 2.3 Invoice (račun) — the central document
Mandatory engine behaviour (enforces [doc 01 §2]):
- **Pre-finalize validation gate** blocks issuing unless every Art. 82 (or Art. 83 simplified)
  field is present and internally consistent (totals foot, VAT per rate correct, supplier &
  premises configured, operator has a tax number, customer VAT ID present for B2B).
- **Line types:** labour, part (standard VAT), part (margin scheme), accessory, fee, discount,
  advance-deduction, environmental/WEEE fee, reverse-charge line.
- **Per-line:** description, qty, unit, unit price (net), discount, VAT rate (from rate table
  valid on supply date), net, VAT, gross. **Margin-scheme lines** carry purchase cost and
  suppress the VAT breakdown (legend printed instead).
- **Header:** issue date, supply date, due date, payment method, premises, device, operator,
  customer (snapshotted), warranty payer if different (warranty repairs), notes/legends
  (reverse charge, margin, exemption, small-taxpayer).
- **Finalize** = (1) allocate gapless number inside the txn, (2) snapshot all data immutably,
  (3) if cash → compute ZOI, enqueue/obtain EOR, (4) render PDF + receipt with QR, (5) append
  to the immutable ledger. After finalize: **no edits**; corrections only (§2.5).
- **Simplified vs full:** the UI defaults to simplified for ≤ €100 B2C cash; one click
  "promote to full invoice" adds buyer details (required if the buyer needs to deduct VAT).

### 2.4 Payments & cash handling
- Record payment(s) against an invoice; partial payments allowed. Fiscalization is derived
  from the **aggregate of payments** (any cash-type payment ⇒ fiscalize; mixed and
  flipped-method cases per the hard rules in [doc 01 §3.1]).
- **Cash sessions (drawer management):** each premises/operator works inside a **CashSession**
  — opened with a counted **opening float**, records non-sale **cash movements** (petty cash
  in/out with reason), and closes with a counted total vs the computed expected amount; the
  **variance** is recorded and must be explained. The daily **Z-report** (gotovinski
  izkupiček) is a generated document referencing the session and every fiscal receipt issued
  within it. Entities in [doc 03 §5].
- POS/card terminal integration optional (capture card vs cash split).

### 2.5 Credit / debit notes & storno (enforces [doc 01 §6])
- Always created **from** an existing invoice; carries the reference, reason code, and the
  lines (full or partial) being corrected.
- Cash refund → fiscalized credit note (own series).
- Append-only: original stays, marked `corrected_by`. The UI "edit issued invoice" action is
  rerouted into a credit-note + replacement chain.

### 2.6 Document outputs (render targets of one invoice object — [doc 01 §7])
1. **PDF** (A4 invoice + thermal receipt) — Slovenian, your branding (the existing
   `printticket.tpl` style/`$_language` i18n can be reused for layout).
2. **Fiscal payload** to FURS (cash invoices).
3. **e-SLOG 2.0 / EN 16931 XML** (B2G now via UJP; B2B switch-on for 2028).
4. **Accounting export** (see §6).

---

### 2.7 Scheduled, recurring & collective invoices
- **Scheduled/deferred** invoices, **recurring** invoices (maintenance/SLA contracts), and
  **collective invoices (zbirni račun)** that consolidate many tickets/deliveries for one
  customer over a VAT period into one multi-line document — full design, legal basis and the
  fiscal-verification rules in **[doc 09](09-scheduled-collective-invoicing.md)**. (Key rule:
  scheduling defaults to non-cash, because cash invoices fiscalize at the point of payment.)

## 3. Parts & purchasing

### 3.1 Parts catalogue (master data)
- SKU, OEM/aftermarket part numbers, compatible device models, supplier(s) & supplier part
  numbers, default cost & sale price, VAT rate, lead time, min/max stock, **serialized?**
  flag (e.g. high-value boards tracked by serial), warranty period from supplier,
  hazardous/battery flag (WEEE).

### 3.2 Purchase orders (naročilnica)
- Raised from: low-stock reorder, forecast, or a specific ticket needing a part not in stock.
- Captures supplier, **supplier VAT ID (VIES-validated)**, country → drives VAT treatment:
  - SI supplier → input VAT 22 %;
  - **EU supplier → intra-Community acquisition, reverse charge self-assessed** ([doc 01 §4.2]);
  - non-EU → import VAT/customs, landed cost ([doc 01 §4.3]).
- States: draft → sent → confirmed → partially/fully received → invoiced → closed.

### 3.3 Goods receipt (prevzem)
- Receive against PO (full/partial). Updates stock, records actual landed cost (incl. freight,
  duty, import VAT) for valuation (doc 07 §inventory). Discrepancies (qty/price) flagged.
- Supplier invoice matched (3-way: PO ↔ receipt ↔ invoice) → posts to received-invoices VAT
  ledger.

### 3.4 RMA to supplier
- Defective/wrong parts returned to supplier under their warranty; tracked so a customer-side
  warranty repair can be reclaimed.

### 3.5 Purchase returns & supplier credit notes
- Wrong/damaged/over-delivered goods (outside warranty RMA) go back with a **purchase return**:
  a reversing StockMovement (return-to-supplier) plus a **SupplierCreditNote** referencing the
  original supplier invoice / goods receipt — correcting the **received-invoices VAT ledger**
  (input-VAT reduction in the period the credit note is issued) and the previously posted
  landed cost/valuation ([doc 07]). Entity in [doc 03 §8].

### 3.6 Pricing & price lists
- Prices resolve through **validity-dated price lists**: customer/contract price list →
  shop/location list → default catalogue price ([doc 03 §7]). B2B fleet/SLA customers get
  negotiated rates; recurring profiles ([doc 09]) reference a price list. The resolved price
  is **snapshotted onto the invoice line** (same pattern as the VAT rate) so later list
  changes never mutate issued documents.

---

## 4. Parts forecasting

Goal: never block a repair for a missing common part; never tie up cash in dead stock.

- **Signals:** historical consumption per part (from tickets), per device-model repair mix,
  seasonality, lead time, open tickets awaiting parts, and **device population trends** (which
  models are coming in for repair now).
- **Methods (incremental):**
  1. **Baseline:** reorder point = (avg daily usage × lead time) + safety stock; min/max levels.
  2. **Moving average / exponential smoothing** per SKU for demand rate.
  3. **Model-driven:** map "incoming device model X" → typical failing parts (screen, battery,
     charge port) to pre-position parts for trending models.
- **Outputs:** suggested purchase orders (one click to raise), st-out risk list, dead-stock /
  slow-mover report, and a forecast-vs-actual accuracy dashboard.
- Keep it explainable (show the inputs behind each suggestion); buyers must trust it.

---

## 5. Stock & technician "warehouses"

### 5.1 Multi-location stock model
A **stock location** is any place inventory physically sits:
- central store(s), each shop's counter stock, **and one virtual warehouse per technician**
  (their bench/van/toolkit).

Every part has a **quantity per location**. Movements are the only way stock changes:

| Movement | Effect |
|----------|--------|
| Goods receipt | + central |
| Transfer | − source, + destination (e.g. central → technician) |
| Consumption on ticket | − technician/shop location, linked to the repair & invoice line |
| Return to stock | + location (unused reserved part) |
| Adjustment (stocktake) | ± with reason, approval, audit |
| Write-off (damaged/WEEE) | − with reason + disposal record (doc 01 §9) |

**Hard stock rules:**
- **No negative stock:** a consumption/transfer that would drive `qty_on_hand` below zero at a
  location is **blocked**; an elevated-permission override (with mandatory reason, audited)
  exists for the real-world "technician consumed from central without transferring first" case
  — the override records the implied transfer rather than going negative silently.
- **Stocktake freeze:** a location in `stocktake_in_progress` blocks new transfers/consumptions
  against it until the count closes; late movements are logged as post-count adjustments.

### 5.2 Technician warehouses — the key design point
- When a technician takes parts from central, that's a **transfer** → the parts now live in
  *their* location and are *their* accountability.
- When they complete a repair, the part is **consumed from their location** and tied to the
  ticket/invoice.
- A **technician reconciliation report** = (transfers in) − (consumed on tickets) − (returned)
  = expected on-hand, compared to a periodic count. Variances are visible and must be
  explained → controls shrinkage and mis-billing.
- Technicians get a **mobile-friendly view** of *their* stock; scanning a part barcode on a
  ticket auto-creates the consumption movement.
- Reservation: parts reserved for a ticket are not double-promised to another job.

### 5.3 Serialized & batch parts
- Serialized parts (expensive components) tracked individually end-to-end (which serial went
  into which device/ticket) — supports warranty/recall and theft control.
- **DOA / mid-repair part swap:** if an installed part turns out dead-on-arrival, the flow is:
  reverse the original consumption with a movement **tagged for supplier RMA** (never back to
  sellable stock), consume the replacement serial, and — if the original was already invoiced —
  issue a credit note + replacement line pair referencing the original document (immutability
  preserved, [doc 01 §6]); `SerialUnit.warranty_until` reflects the part actually installed.

### 5.4 Valuation
- Inventory valued per SRS/IAS 2 — **weighted-average or FIFO** at cost (purchase price +
  import duty + freight, less rebates). Method is a config choice, applied consistently
  (doc 07 §inventory). Stock value feeds the accounting export and balance-sheet figures.

---

## 6. Export, reporting & accountant hand-off

### 6.1 Statutory / tax exports ([doc 01 §8])
- **VAT books:** issued-invoices and received-invoices ledgers — **submitted to FURS as
  structured XML via eDavki every period (mandatory since 1 July 2025**, [doc 01 §8]).
- **DDV-O** figures (VAT return), **RP-O** (recapitulative/EC Sales List), and the **Art.
  76.a report (form PD-O)** when used.
- **Intrastat** dataset + threshold-tracking alert.
- All exportable in the **eDavki XML schemas** and as CSV/XLSX for the accountant.

### 6.1a Receivables & dunning (B2B on-credit invoices)
- Overdue-invoice dashboard (ageing buckets), **configurable reminder cadence** (email/SMS,
  per-locale templates), optional statutory late-payment interest line, escalation notes, and
  a privileged **write-off to bad debt** action posting per [doc 07 §5]. Ties the operational
  collections flow to the accounting treatment.

### 6.2 Accounting integration
- **Journal export** to the accounting package (e.g. via the unified chart-of-accounts mapping,
  doc 07) — sales, purchases, inventory movements, COGS, payments. Prefer a **standard
  interchange** (e.g. e-SLOG for invoices + a posting file) over bespoke CSV where possible.
- **General-ledger posting rules** per document type are configurable (account mapping table).

### 6.3 Management reporting
- Revenue by service type / device model / technician; margin per repair; parts margin;
  technician utilization; turnaround time; warranty-claim rate; stock turnover & ageing;
  forecast accuracy; cash reconciliation.

### 6.4 Data export & portability
- Full export of a customer's data (GDPR portability, doc 05), and bulk export of any dataset
  (CSV/XLSX/JSON) with permission controls and audit logging.

---

## 7. Roles & screens (functional view)

| Role | Can | Notably cannot |
|------|-----|----------------|
| Technician | See own tickets & own stock, log labour, consume parts, request transfers, create draft invoices | Finalize/refund without rights; see other techs' stock unless granted |
| Counter/cashier | Intake, estimates, finalize cash invoices (has tax no.), take payment, credit notes (limited) | Change rates, edit closed periods |
| Buyer/stock manager | POs, goods receipt, transfers, stocktakes, forecasting | Issue invoices (unless also cashier) |
| Accountant (internal/external) | All exports, VAT reports, read-only ledger | Edit finalized fiscal documents (nobody can) |
| Admin | Master data, premises/devices, users, rate tables, integrations | Bypass the append-only ledger |

(Full RBAC + auth in [doc 05](05-security-gdpr.md).)
