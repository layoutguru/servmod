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
        │                                  declines → return device, close, (diag fee?)
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
- Record payment(s) against an invoice; partial payments allowed. Payment method drives
  fiscalization. Cash drawer / daily Z-report (gotovinski izkupiček) per business premises &
  operator for reconciliation.
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
  **collective invoices (zbirni/skupni račun)** that consolidate many tickets/deliveries for one
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

### 5.4 Valuation
- Inventory valued per SRS/IAS 2 — **weighted-average or FIFO** at cost (purchase price +
  import duty + freight, less rebates). Method is a config choice, applied consistently
  (doc 07 §inventory). Stock value feeds the accounting export and balance-sheet figures.

---

## 6. Export, reporting & accountant hand-off

### 6.1 Statutory / tax exports ([doc 01 §8])
- **VAT books:** issued-invoices and received-invoices ledgers.
- **DDV-O** figures (VAT return), **PD-O**, **RP-O** (recapitulative/EC Sales List), **Art.
  76.a report** when used.
- **Intrastat** dataset + threshold-tracking alert.
- All exportable as the **eDavki-expected formats** and as CSV/XLSX for the accountant.

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
