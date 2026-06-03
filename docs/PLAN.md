# servmod ERP — Complete Design & Compliance Plan

_Single-file edition — auto-assembled from the canonical chapter files in `docs/` (01–11). Generated 2026-06-03. If anything here and a chapter file disagree, the chapter file wins._

> ⚠️ **Not legal/tax advice.** Engineering design grounded in public sources (FURS technical documentation, ZDDV-1, ZDavPR, SRS 2024, SPOT/EU guidance). Slovenian tax/accounting law changes frequently — every rate, threshold, deadline, report format and legend must be confirmed with the company's accountant (računovodja) and against the current FURS technical specification before go-live.

## Overview — the shape of the problem

You repair devices. A repair generates a **service ticket** (you already have this in
`servmod`, Smarty templates, Slovenian UI). When the job is done you must **issue a legally
valid invoice**, and if it is paid in cash/card it must be **fiscally verified by FURS in
real time** (ZOI + EOR + QR on the receipt). Parts consumed on the repair must come out of a
**stock location** — and because technicians carry parts in their vans/benches, each
technician is effectively a **mobile sub-warehouse** whose consumption must reconcile against
the central store. Parts you don't have you **order** from suppliers (often intra-EU,
triggering reverse-charge VAT and possibly Intrastat/EC-Sales reporting); parts you *will*
need you **forecast**. Mistakes and returns become **credit notes (dobropisi)**. Everything
must be **exportable** for the accountant and **retained for 10 years**, and the whole system
holds customer personal data so it must be **GDPR-grade secure**.

## Contents

- [01 — Legal & Compliance Analysis (Slovenia)](#doc01)
- [02 — ERP Functional Design](#doc02)
- [03 — Data Model](#doc03)
- [04 — Architecture & Integrations](#doc04)
- [05 — Security & GDPR](#doc05)
- [06 — Delivery Roadmap](#doc06)
- [07 — Accounting Standards (Slovenia & EU)](#doc07)
- [08 — UI / UX Design System ("servmod glass")](#doc08)
- [09 — Scheduled, Recurring & Collective Invoices (zbirni/skupni račun)](#doc09)
- [10 — ServiceApp Integration & Billing Migration](#doc10)
- [11 — Outside-the-Box Features (high-value extensions)](#doc11)


<a id="doc01"></a>

# 01 — Legal & Compliance Analysis (Slovenia)

This is the load-bearing chapter. The ERP's job is to make it *impossible* for a normal user
to produce a non-compliant document. Everything in documents 02–06 exists to enforce what is
written here.

**Primary legal instruments**

| Short name | Full name | Scope for us |
|------------|-----------|--------------|
| **ZDDV-1** | Zakon o davku na dodano vrednost | VAT: rates, invoice content, credit notes, reverse charge, margin scheme, place of supply, returns. |
| **Pravilnik o izvajanju ZDDV-1** | Implementing rules for ZDDV-1 | Detailed invoice/record rules. |
| **ZDavPR** | Zakon o davčnem potrjevanju računov | **Fiscal verification** of cash invoices (ZOI/EOR, QR, business premises, internal act). In force since 2 Jan 2016. |
| **ZDavPR technical documentation** | FURS "Davčno potrjevanje računov / Fiscal verification of invoices" (currently ≈ v3.1) | The exact XML/JSON schemas, ZOI algorithm, certificates, test env. |
| **ZEPDESED / e-invoice act** | Zakon o izmenjavi elektronskih računov in drugih elektronskih dokumentov (adopted 23 Oct 2025) | Mandatory B2B **e-invoicing** (e-SLOG/EN 16931), phased from **1 Jan 2028**. |
| **ZDavP-2** | Zakon o davčnem postopku | Record-keeping, retention, tax procedure. |
| **GDPR + ZVOP-2** | EU 2016/679 + Slovenian Personal Data Protection Act | Customer/employee personal data (see [doc 05](#doc05)). |

---

## 1. VAT (DDV) fundamentals

### 1.1 Rates (confirm annually with accountant)

| Rate | Code | Applies to (relevant to us) |
|------|------|-----------------------------|
| **22 %** | `S` standard | The default for device-repair labour and almost all spare parts, accessories, electronics. |
| **9.5 %** | `R1` reduced | Specific listed goods/services (food, certain repairs of private dwellings, etc.). **Repair of electronic devices is generally NOT 9.5 %** — treat 22 % as default and only apply 9.5 % where the accountant confirms a listed category (e.g. certain repairs of household appliances under the "repair of private dwellings" provisions, if applicable). |
| **5 %** | `R2` super-reduced | Books/e-books, etc. Not relevant to repairs. |
| **0 % / exempt with credit** | `Z` | Exports of goods outside the EU, intra-Community supplies of goods to a VAT-registered EU business, international transport. |
| **Exempt without credit** | `E` | Art. 44 exemptions (finance, insurance, etc.) — rare for us. |
| **Out of scope / reverse charged** | `AE` / `R` | See §4. |

> **Design rule:** rates are **data, not code**. Store a `tax_rate` table with validity dates
> (`valid_from`, `valid_to`) so a rate change (e.g. a future budget) is a config change, never
> a deploy. Every invoice line references a rate *as it was on the supply date*.

### 1.2 Who must charge VAT
- A business becomes liable to register for VAT once taxable turnover in the last 12 months
  exceeds the registration threshold (historically **€50,000**, with an EU SME cross-border
  scheme on top). **Confirm the current threshold.** Below it, a business may be a
  *small taxpayer* (mali davčni zavezanec) and issues invoices **without VAT**, with the
  legend *"DDV ni obračunan na podlagi 1. odstavka 94. člena ZDDV-1"* (or the applicable
  article). The ERP must support **both modes** via a company-level flag, because kron.si may
  be VAT-registered today but the software should not hard-code it.

### 1.3 Tax point / chargeability
VAT generally becomes chargeable when the supply is made (repair completed / parts handed
over) or when an **advance payment** is received (then an advance invoice is due). The ERP's
invoice date and supply date (`datum opravljene storitve/dobave`) are **separate fields** and
both appear on the document.

---

## 2. What a legally valid invoice must contain (ZDDV-1 Art. 82)

A **full invoice** for a VAT taxpayer must show:

1. **Date of issue.**
2. **Sequential invoice number** that uniquely identifies the invoice (see §5 numbering — and
   note fiscalized invoices have an even stricter structure).
3. **Supplier:** full name/firm, address, and **VAT ID** (`davčna/identifikacijska številka
   za DDV`, format `SIxxxxxxxx`).
4. **Customer:** name and address; and the **customer's VAT ID** when the customer is a
   taxable person/legal entity (mandatory for B2B and for reverse-charge supplies).
5. **Quantity and type** of goods, or **extent and type** of services (e.g. "Diagnostika in
   menjava zaslona — iPhone 13", "Nadomestni del: zaslon LCD …", qty, unit).
6. **Date of supply / completion** of goods/services (or advance payment date) if different
   from issue date.
7. For each VAT rate or exemption: **taxable amount (net)**, **unit price excl. VAT**, and any
   **discounts/rebates** not in the unit price.
8. **VAT rate(s) applied.**
9. **VAT amount payable** (per rate), unless a special scheme applies.
10. In case of **exemption / reverse charge / margin scheme**: the relevant **clause**
    referencing the ZDDV-1 article or the Directive 2006/112/EC article, or the wording
    *"Reverse charge" / "Obrnjena davčna obveznost"*, *"Maržna ureditev — rabljeno blago"*,
    *"Oproščeno DDV po … členu ZDDV-1"*, etc.
11. If self-billed: *"Samofakturiranje"*. If a tax representative is liable: their details.

### 2.1 Simplified invoice (Art. 83) — important for a repair counter
A **simplified invoice** may be issued when the total **value incl. VAT does not exceed €100**,
and for retail/B2C cash sales. It can omit some fields but **must** include:
- date of issue; a sequential number;
- supplier name + address + VAT ID;
- quantity/type of goods or extent/type of services;
- the amount of VAT payable **or the information needed to calculate it** (e.g. gross amount +
  rate);
- a clear reference to the original invoice if it is a correcting document.

If the customer is another taxable person who needs the invoice to **deduct input VAT**, the
simplified invoice must **also** show the **buyer's name and address**. → The ERP must let the
counter "promote" a simplified receipt to a full invoice by adding buyer details, *before*
fiscalization is finalized.

### 2.2 Language, currency, rounding
- Slovenian language; EUR currency. If issued in another currency, the **VAT amount must also
  be shown in EUR** using the ECB/Banka Slovenije reference rate on the tax-point date.
- Rounding: compute VAT per rate group on the summed net, then round to **2 decimals**
  (round-half-up). Keep line-level values at higher precision internally to avoid drift; the
  *printed* totals must foot exactly.

---

## 3. Fiscal verification of invoices — ZDavPR ("davčna blagajna") ⭐

This is the single most compliance-critical subsystem. **Every invoice paid in cash must be
fiscally verified by FURS in real time, before it is handed to the customer.**

### 3.1 When does it apply?
- It applies to invoices for **cash payments**. In ZDavPR, **"cash" (plačilo z gotovino) is
  broad**: banknotes/coins, **payment cards, cheques, and other comparable means** where
  payment is *not* made by direct bank transfer to the supplier's account.
- **Direct bank transfer (UPN/TRR), invoice paid later by wire → NOT subject to fiscal
  verification.** (But it is still a normal ZDDV-1 invoice.)
- Applies to **all** persons who issue invoices for cash and keep business books — **including
  small (non-VAT) taxpayers**. So even if kron.si were below the VAT threshold, cash invoices
  still need fiscalization.

> **Design consequence:** the *payment method* chosen at the point of issue decides whether the
> document must go through the FURS round-trip. The ERP must therefore know the payment method
> **at issue time**, and re-fiscalize if a draft is later paid in cash.

### 3.2 Prerequisites (one-time setup, before the first fiscalized invoice)
1. **Dedicated digital certificate** for fiscal verification, obtained from FURS (the
   issuance was moved to FURS; previously MJU). Used to sign the ZOI and authenticate to the
   FURS web service.
2. **Register every business premises** (`poslovni prostor`) via **eDavki** *before* issuing
   the first invoice from it. Each gets a **Business Premises ID** (you choose the label).
   Premises can be **immovable** (a shop — needs the cadastral data: building/part numbers) or
   **movable/portable** (e.g. a technician's mobile unit / "type C" premises). **A
   technician's van or field-repair kit may need to be registered as a movable premises if
   cash invoices are issued there.**
3. **Internal act (`interni akt`)**: a written internal rulebook defining the business
   premises, the numbering of premises and electronic devices, and the rules for assigning
   invoice numbers. Must be retained and producible on demand.
4. Register/identify each **electronic device** (`elektronska naprava`) used to issue
   invoices.

### 3.3 The invoice number structure (mandatory for fiscalized invoices)
The number is a **three-part token**:

```
<BusinessPremisesID>-<ElectronicDeviceID>-<SequentialNumber>
e.g.  POSLOVALNICA1-BLAG1-2026-000123   (label format is your choice within rules)
```
- The **sequential number must be continuous, gapless, and ascending** per (premises, device)
  combination within a **calendar year** (reset annually only if your internal act says so —
  many keep continuous; **decide in the internal act and encode that choice as config**).
- The ERP must guarantee **no gaps and no reuse**, even under concurrency/crash — see
  [doc 03 §numbering](#doc03) (DB sequence per premises+device, allocated inside the
  same transaction that persists the invoice).

### 3.4 ZOI — Zaščitna oznaka izdajatelja (issuer protective mark)
Computed **locally by the ERP** (proves the invoice originated from you even if FURS is
temporarily unreachable):

1. Concatenate, as a single string, in the FURS-specified order:
   - issuer **tax number**,
   - **date & time** of issue (format per spec),
   - **invoice number** (sequential part),
   - **business premises ID**,
   - **electronic device ID**,
   - **invoice total amount**.
2. **Sign** that string with the **private key** of the digital certificate using **RSA with
   SHA-256**.
3. Take the **MD5 hash** of the signature and render it as a **32-character lowercase hex
   string** → that is the **ZOI**.

The ZOI is printed on the receipt and embedded in the QR/PDF417/Code128.

### 3.5 EOR — Enkratna identifikacijska oznaka računa (unique invoice ID from FURS)
1. Send the invoice payload (issuer tax no., premises, device, number, timestamp, amounts per
   VAT rate, **operator's tax number**, payment type, the ZOI, etc.) to the **FURS web
   service** over a mutually-authenticated TLS channel, message **signed with the
   certificate**, payload as **XML (SOAP) or JSON**.
2. FURS validates and returns the **EOR** (unique invoice mark).
3. The receipt is printed **with both ZOI and EOR** and given to the customer.

### 3.6 Offline / FURS-unreachable path (must be designed, not optional)
- If FURS cannot be reached at issue time, you **may still issue** the invoice **with the ZOI
  only** (no EOR yet).
- You **must obtain the EOR within 48 hours (2 business days)** by re-sending the stored
  invoice once connectivity returns.
- The ERP needs a **durable retry queue** of un-verified invoices, a worker that drains it,
  alerting if anything approaches the 48h limit, and a way to reprint/record the EOR once
  received. **This queue is mission-critical** — see [doc 04 §FURS service](#doc04).

### 3.7 The QR / barcode on the receipt
- The receipt carries a machine-readable code (**QR**, or **PDF417**, or **Code 128**)
  encoding a numeric string derived from the **ZOI + issuer tax number + timestamp**, plus a
  check digit, per the FURS spec — so a customer/inspector can verify the invoice on the FURS
  app/portal.
- Also human-readable on the receipt: **ZOI**, **EOR**, date/time of issue, premises &
  device, and the **operator (cashier) identifier**.

### 3.8 Operator (issuer of the individual invoice)
- Each fiscalized invoice reports the **tax number of the natural person who issued it**
  (the cashier/technician). → Every ERP user who can finalize a cash invoice must have a
  **stored tax number** (`davčna številka`), treated as personal data (doc 05).

### 3.9 Failure modes the design must handle
- FURS down at issue → offline path (§3.6).
- Certificate expiry → monitor & alert ≥ 30 days ahead; certs rotate.
- Crash between "number allocated" and "EOR received" → on restart, the invoice is in
  `PENDING_EOR`, the queue resends; **never** re-allocate the number.
- A fiscalized invoice is **immutable**: corrections are *new* documents (credit note /
  storno), each itself fiscalized if cash — see §6.

---

## 4. Reverse charge, EU trade, margin scheme (matter a lot for a repair shop buying parts)

### 4.1 Domestic reverse charge (ZDDV-1 Art. 76.a)
Liability shifts to the **buyer** for specific listed supplies — principally **construction
work, supply of staff for it, certain immovable property, waste/scrap & recyclable material,
and greenhouse-gas allowances**. These require the legend *"Obrnjena davčna obveznost"* and a
**special Art. 76.a report**.
- **Relevance to us:** mostly when **selling scrap/e-waste** (old boards, batteries handed to
  a recycler that is a taxable person) → may fall under the **waste/scrap** category. Build the
  *capability* (a `reverse_charge_76a` flag + the report), but the common repair sale is
  ordinary 22 %. **Do not** assume mobile phones/laptops are domestic-reverse-charged in
  Slovenia — that optional EU category is **not** how the standard SI list reads; confirm with
  the accountant before enabling.

### 4.2 Intra-EU acquisition of parts (the everyday case)
- Buying spare parts from a VAT-registered supplier in another EU member state: the supplier
  invoices **0 %**, and **you self-assess Slovenian VAT** (acquisition VAT) on your VAT return
  — output and input VAT net to zero if fully deductible, but **both must be recorded**.
- The ERP's **purchase/parts-order module must capture**: supplier VAT ID (validate via
  **VIES**), country, whether it's an intra-EU acquisition, and book the reverse-charge VAT.
- **Recapitulative report (RP-O / EC Sales List):** filed for intra-EU **supplies** (when you
  *sell* cross-border) by the 20th of the following month. Acquisitions feed the VAT return
  (and the **RP-O on the dispatch side** is for sales). Build both directions even if
  acquisitions dominate.
- **Intrastat:** monthly, only once you cross the annual thresholds — **2026: ≈ €300,000
  arrivals / €280,000 dispatches** (confirm). Below threshold → no Intrastat. The ERP should
  **track cumulative intra-EU goods movements** and **alert** when approaching the threshold.

### 4.3 Imports from outside the EU
- Parts from non-EU (e.g. CN): **import VAT + possibly customs duty** at clearance. Capture
  customs declaration (MRN), import VAT (often deferred/self-assessed via the VAT return), and
  landed cost into part cost.

### 4.4 Margin scheme — second-hand goods (ZDDV-1 special scheme)
If kron.si **buys and resells used devices** (trade-ins, refurbished phones bought from
private individuals/non-taxable persons), the **margin scheme** lets you charge VAT only on
the **margin** (sale − purchase), not the full price, and **no VAT is shown separately** on the
sale invoice — instead the legend *"Posebna ureditev — rabljeno blago / margin scheme"*.
- The ERP must support a **margin-scheme item type**: track per-unit purchase cost, compute
  VAT on margin, suppress the VAT breakdown on the customer document, and keep a **separate
  margin-scheme register**. Standard-VAT and margin-scheme lines **cannot** be mixed loosely;
  keep them in distinct line types/registers.

### 4.5 Warranty repairs
- Repair done under **manufacturer warranty**, billed to the **manufacturer/importer** (not
  the consumer): a normal B2B invoice to the warrantor (22 %, or reverse charge / intra-EU if
  the warrantor is abroad). The consumer pays €0 but **still receives documentation**; if no
  payment is taken, no fiscal verification is triggered (no cash). Model "warranty payer" as
  a billing party distinct from the device owner.

---

## 5. Invoice numbering — the rules, consolidated

| Document type | Numbering requirement |
|---------------|-----------------------|
| Fiscalized (cash) invoice | `Premises-Device-Sequence`, gapless & ascending per (premises, device) within the period defined in the internal act (see §3.3). |
| Non-cash invoice (bank transfer) | Sequential & unique; the company may use a separate series, but it must be systematic and described in internal rules. |
| Credit note / storno | Its own sequence; **must reference the original invoice number** (§6). |
| Advance (proforma) | Proformas are **not** tax invoices and **not** fiscalized; they get their own non-tax series. The *advance invoice* issued on receiving payment **is** a tax document. |

**Hard invariants the ERP enforces:** no gaps, no reuse, no back-dating into a closed period,
no editing a finalized number. Allocation happens **inside the DB transaction** that commits
the (immutable) document — see [doc 03](#doc03).

---

## 6. Corrections: credit notes (dobropis), debit notes, storno

A finalized/fiscalized invoice is **never edited or deleted**. You correct with a **new
document**:

- **Credit note (dobropis):** reduces the original (return of a part, price reduction, wrong
  charge). Must contain all Art. 82 elements **plus an explicit reference to the original
  invoice** (number + date) and the reason. VAT is corrected per ZDDV-1 (the supplier reduces
  output VAT; if the buyer deducted input VAT they must correct it — the document is the
  evidence). If the original was a **cash** invoice, the credit note that returns cash is
  **itself fiscally verified** (it's a cash transaction → ZOI/EOR).
- **Debit note (bremepis):** increases the original (under-charged). Same referencing rules.
- **Storno (full cancellation):** a credit note for the full amount; the original remains in
  the ledger (visible, marked corrected) — it is *not* removed.
- **VAT correction timing:** corrections that reduce the tax base generally require the
  corrected document and, where the buyer is a taxable person, evidence they adjusted their
  deduction (ZDDV-1 rules). Surface the **reason code** and link, and report the correction in
  the **period the credit note is issued** (subject to accountant's confirmation).

> **Design rule:** the immutable fiscal ledger only ever **appends**. "Editing" an issued
> invoice in the UI actually creates a linked credit note + (optionally) a fresh corrected
> invoice. The chain `original → credit note → replacement` is fully traceable.

---

## 7. E-invoicing (e-SLOG) — where it's going

- **B2G is already mandatory:** invoices to public-sector bodies must be **e-SLOG** e-invoices
  delivered via **UJP** (Uprava za javna plačila). If kron.si ever invoices a public hospital,
  school, ministry, etc., this is required **today**.
- **B2B becomes mandatory:** the *Act on the exchange of electronic invoices and other
  electronic documents* was adopted **23 Oct 2025**; mandatory B2B e-invoicing is scheduled to
  **phase in from 1 Jan 2028** (earlier 2026/2027 proposals were pushed back; the adopted
  version also dropped a real-time CTC e-reporting-to-FURS requirement). **Accepted formats:
  e-SLOG 2.0 (national), EN 16931 (EU semantic standard), and other mutually agreed
  standards.** **B2C is not in scope.**
- **eDavki e-VAT:** VAT records/returns submitted electronically via eDavki (the pre-filled
  VAT ledger initiative tightened reporting from mid-2025). Our exports must match eDavki
  expectations.

> **Design consequence:** model invoices **semantically** (a clean internal invoice object)
> and treat **e-SLOG/EN 16931 XML as one of several render targets** (alongside the PDF and
> the fiscal-verification payload). Build the e-SLOG exporter now (even if optional until
> 2028) so B2G works immediately and the B2B mandate is a switch-flip. Plan for a delivery
> channel (UJP for B2G; an access point / the future SI exchange route for B2B).

---

## 8. Books, records & retention (ZDDV-1 / ZDavP-2)

- **VAT ledgers:** keep the **issued-invoices book** and **received-invoices book** (knjiga
  izdanih/prejetih računov) with all data needed for the VAT return. The ERP generates both.
- **Retention:** **invoices and accounting records — 10 years**; **real-estate-related — 20
  years**. Records must remain **authentic, integral and legible** for the whole period.
- **Electronic storage** is permitted if it prevents alteration/deletion and allows
  reproduction in original form → append-only fiscal ledger + WORM/immutable archive +
  integrity hashing (doc 05).
- **VAT return (DDV-O):** typically **monthly** (or quarterly for smaller taxpayers), due by a
  fixed day of the following month; **RP-O** recapitulative by the 20th. The ERP must export
  the figures that populate each box of **DDV-O**, **PD-O**, **RP-O**, and the **Art. 76.a
  report** where used.

---

## 9. Consumer-protection / sector rules that touch the documents

- **Repair estimates & consent:** Slovenian consumer-protection practice expects a **cost
  estimate (predračun)** and customer approval before chargeable work, and a **warranty on the
  repair** itself. Model: estimate → customer approval (timestamped, ideally e-signed) →
  work → invoice.
- **Warranty / guarantee tracking:** track the repair warranty period and the parts' supplier
  warranty (for your own RMA back to the supplier).
- **WEEE / battery handling:** disposal of e-waste and batteries has environmental-fee and
  documentation implications; capture it as part of stock write-off (doc 02 §stock).
- **Spare-parts "right to repair":** EU rules increasingly require parts availability and
  documentation; not a software blocker but informs the parts catalogue/lifecycle data.

---

## Compliance checklist (traceability matrix)

| Requirement | Enforced by | Doc |
|-------------|-------------|-----|
| Art. 82 invoice fields present | Invoice template + validation gate before finalize | 02 §invoices, 03 |
| Simplified invoice ≤ €100 + buyer details when deductible | Document-type rules | 02 |
| Gapless sequential numbering per premises+device | DB sequence inside finalize txn | 03 |
| ZOI computed (RSA-SHA256 → MD5 → 32 hex) | FURS fiscalization service | 04 |
| EOR obtained in real time; ≤48h offline fallback | Durable verification queue + worker | 04 |
| QR/PDF417 + ZOI/EOR/operator on receipt | Receipt renderer | 02, 04 |
| Business premises + devices registered; internal act | Setup/admin module + config | 02, 03 |
| Operator tax number on each cash invoice | User profile (encrypted PII) | 03, 05 |
| Credit/debit notes reference original; append-only | Immutable ledger + correction flow | 02, 03 |
| Intra-EU acquisition reverse charge + VIES + RP-O | Purchasing module + tax engine | 02, 04 |
| Intrastat threshold tracking & alert | Reporting module | 02 |
| Margin scheme register (if reselling used) | Item type + separate register | 02, 03 |
| e-SLOG 2.0 / EN 16931 export; UJP for B2G | e-invoice exporter (render target) | 04 |
| 10-year immutable, legible retention | WORM archive + integrity hashes | 05 |
| DDV-O / PD-O / RP-O / 76.a exports | Reporting module | 02 |
| Personal data protected (GDPR/ZVOP-2) | Whole of doc 05 | 05 |

---

## Sources

Public sources consulted (June 2026). **Re-verify against the live FURS technical
documentation and the accountant before go-live.**

- FURS — *Davčno potrjevanje računov / Fiscal verification of invoices*, technical
  documentation (v3.1 and earlier): https://www.datoteke.fu.gov.si/dpr/files/TehnicnaDokumentacijaVer3.1.pdf
- FURS — *Fiscal verification of invoices and pre-numbered receipt book*: https://www.fu.gov.si/en/supervision/areas_of_work/fiscal_verification_of_invoices_and_pre_numbered_receipt_book
- FURS — *Value added tax (VAT)*: https://www.fu.gov.si/en/taxes_and_other_duties/areas_of_work/value_added_tax_vat
- FURS — *Invoicing*: https://www.fu.gov.si/en/poslovni_dogodki_podjetja/invoicing
- SPOT (state portal) — *Invoicing*: https://spot.gov.si/en/info/accountancy/invoicing
- RRA Koroška — *VAT taxpayer or small taxpayer? How to issue an invoice correctly* (Art. 82/83 walk-through): https://rra-koroska.si/en/spot-consulting-koroska/articles-prepared-by-spot-consultants/vat-taxpayer-or-small-taxpayer-how-to-issue-an-invoice-correctly-in-every-situation
- European Commission — *Slovenia VAT rules (OSS)*: https://vat-one-stop-shop.ec.europa.eu/national-vat-rules/slovenia-vat-rules_en
- European Commission — *eInvoicing in Slovenia*: https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/eInvoicing+in+Slovenia
- vatcalc — *Slovenia VAT guide 2026*: https://www.vatcalc.com/slovenia/slovenia-vat-guide/
- vatcalc — *Slovenia B2B e-invoicing e-SLOG Jan 2028 update*: https://www.vatcalc.com/slovenia/slovenia-b2b-e-invoicing-e-slog-on-pause/
- Sovos — *Slovenia E-Invoicing: B2B & B2G Mandates*: https://sovos.com/vat/tax-rules/slovenia-e-invoicing/
- efsta — *Slovenia fiscalization (ZDavPR)*: https://en.efsta.eu/fiskalisierung/slowenien
- Fiscal Solutions — *Slovenia: dedicated digital certificate mandatory*: https://www.fiscal-requirements.com/news/4823
- Računovodstvo Promotiv — *Fiscal verification of invoices / cash registers*: https://www.promotiv.si/en/fiscal-verification-of-invoices-fiscal-cash-registers/
- Thomson Reuters — *Slovenia domestic reverse charge*: https://www.thomsonreuters.com/content/dam/helpandsupp/en-us/Topics/os-determination/files/content-updates/slovenia-domestic-reverse-charge-intl-2020.pdf
- Avalara — *Slovenian EC Sales Lists*: https://www.avalara.com/vatlive/en/country-guides/europe/slovenia/slovenian-ec-sales-lists-esl.html
- Global VAT Compliance — *Intrastat & EC Sales List in Slovenia*: https://www.globalvatcompliance.com/intrastat-ec-sales-list-slovenia/
- Open-source reference implementation of ZOI/EOR (study only): https://github.com/matixmatix/furs_fiscal_verification


---


<a id="doc02"></a>

# 02 — ERP Functional Design

How the repair business actually flows, and which legal documents ([doc 01](#doc01))
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
  fiscal-verification rules in **[doc 09](#doc09)**. (Key rule:
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

(Full RBAC + auth in [doc 05](#doc05).)


---


<a id="doc03"></a>

# 03 — Data Model

Entities and the invariants that make the system compliant. Notation is database-agnostic
(targets **MariaDB / InnoDB** as the primary store, with a portable abstraction for other
RDBMS — [doc 04 §2.1]). PII columns are marked 🔒 and
are encrypted/access-controlled per [doc 05](#doc05).

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
AuditEvent (append-only) ; immutable FiscalLedger (append-only)
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

**NumberSequence**: `(premises_id, device_id, series, year)` → `next_value`. Allocation is
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

**Ticket**: number, customer, device, status (state machine — doc 02 §1), assigned technician,
intake notes, fault, diagnosis, warranty flag + warranty payer, timestamps, consent record ref.

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
- `issue_datetime`, `supply_date`, `due_date`, `payment_method`,
- `currency`, `fx_rate` (+ EUR equivalents if non-EUR),
- totals per VAT-rate group (`net`, `vat`, `gross`), grand totals,
- `legends` (reverse charge / margin / exemption / small-taxpayer text),
- `is_fiscalized` (bool), `fiscal_record_id` (nullable),
- `corrected_by_creditnote_id` (nullable), `replaces_invoice_id` (nullable),
- `content_hash` (SHA-256 over canonical serialization → tamper-evidence, doc 05).

**InvoiceLine**: invoice, seq, `line_type` (labour/part/part_margin/accessory/fee/discount/
advance_deduction/weee/reverse_charge), description, qty, unit, unit_price_net, discount,
`vat_rate_ref` (the rate **as of supply_date**), net, vat, gross, `margin_cost` (for
margin-scheme lines), source refs (part_id / ticket_line_id).

**Payment**: invoice, amount, method, datetime, operator, (card auth ref).

**CreditNote / DebitNote**: own number/series, `original_invoice_id` (**required**), reason
code, lines (full/partial), totals, `is_fiscalized`, `fiscal_record_id`, `content_hash`.
Modeled as an Invoice subtype with `sign = -1` to keep one ledger.

**FiscalRecord** (1:1 with a fiscalized document — [doc 01 §3]):
- `zoi` (32 hex), `eor` (nullable until verified), `qr_payload`,
- `operator_tax_number` 🔒, `issue_datetime`, premises/device/number echo,
- `verification_status` (`PENDING_EOR` / `VERIFIED` / `FAILED`),
- `submitted_at`, `verified_at`, `attempts`, `last_error`,
- `protocol` (real-time vs subsequent ≤48h), `message_id`.

## 6. Numbering & immutability invariants (critical)

1. **Gapless, ascending** per `(premises, device, series, year)`. Allocate `next_value` with
   `SELECT ... FOR UPDATE` / `UPDATE ... RETURNING` **inside the same transaction** that
   inserts the finalized invoice. If the transaction rolls back, the number is **not** burned
   (or, if a strict no-gap is impossible to guarantee under a crash window, reconcile on
   recovery — never silently skip). Document the chosen guarantee in the internal act.
2. **No edit, no delete** of finalized invoices/credit notes/fiscal records — enforced at the
   DB **and** app layer. On **MariaDB**: a restricted app DB user **without** UPDATE/DELETE
   grants on the ledger tables, **plus** `BEFORE UPDATE`/`BEFORE DELETE` triggers that
   `SIGNAL SQLSTATE '45000'` to hard-block tampering even by a privileged connection. (On
   PostgreSQL the same is done with `REVOKE` + rules — [doc 04 §2.1].)
3. **content_hash chaining (optional but recommended):** each ledger row stores the hash of
   the previous finalized document → a hash chain that makes silent back-dating/insertion
   detectable.
4. **No back-dating into a closed VAT period.** `issue_datetime` validated against period locks.
5. **PENDING_EOR is a valid issued state** — the document exists with ZOI; EOR fills in later.

## 7. Inventory

**Part**: SKU, names (SL), oem/aftermarket numbers, compatible models (M:N to device models),
`vat_rate_ref`, default cost, default price, `is_serialized`, `is_hazardous`/WEEE,
min/max/reorder point, lead_time_days, supplier warranty days, status.

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


---


<a id="doc04"></a>

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
| Queue/jobs | **Durable queue** (DB-backed table, or Redis/RabbitMQ) | EOR retry, **scheduled & recurring invoices** ([doc 09](#doc09)), e-invoice dispatch, forecasting jobs. |
| Frontend | Server-rendered + progressive JS, mobile-first technician views | Counter speed + van use. |
| Cache | Redis (optional) | Catalogue, stock levels. |
| Object/WORM store | S3-compatible with **object-lock / immutability** | 10-year retention of PDFs/XML/fiscal payloads (doc 01 §8). |
| Frontend UI/UX | **Modern dark/light "Apple-glass" design system** | Full spec in [doc 08](#doc08). |

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


---


<a id="doc05"></a>

# 05 — Security & GDPR

The ERP holds **customer personal data** (names, addresses, phones, emails, device serials/
IMEIs, repair history — sometimes the device contents are visible during repair) and
**employee personal data** (incl. tax numbers used as fiscal operators). That makes
security and data protection a **first-class requirement, not a bolt-on**. This chapter is
deliberately detailed because you asked to emphasise it.

**Governing law:** **GDPR (EU 2016/679)** + Slovenia's **ZVOP-2** (national Data Protection
Act), supervised by the **Information Commissioner (Informacijski pooblaščenec, IP-RS)**.

---

## 1. Authentication — passkeys first, strong MFA always

### 1.1 Passkeys / WebAuthn (primary, phishing-resistant)
- Implement **WebAuthn / FIDO2 passkeys** as the **preferred** login method for all staff.
- Support **platform authenticators** (Touch ID/Windows Hello/Android biometrics on the
  device) and **roaming authenticators** (hardware security keys, e.g. YubiKey) for shared
  shop terminals.
- **Discoverable credentials (resident keys)** + **user verification required** (biometric/PIN)
  so a passkey alone = two factors (possession + inherence).
- Per-user **multiple credentials** (a key per device + a backup key) to avoid lock-out;
  enforce **at least one backup** at enrolment.
- Store only **public keys + credential metadata** (credential id, AAGUID, sign-count, created/
  last-used). Verify **sign-count** to detect cloned authenticators. Bind to the correct
  **RP ID / origin** to stop phishing.
- **Account recovery** is the dangerous part: recovery requires admin approval + a second
  verified factor + full audit; never a simple "email me a reset link" for privileged roles.

### 1.2 2FA / MFA fallback (where passkeys aren't yet available)
- **TOTP** (RFC 6238 authenticator apps) as fallback second factor; secret stored
  **encrypted** 🔒. Optionally **WebAuthn as second factor** on top of password.
- **SMS OTP is discouraged** (SIM-swap) — offer only as last-resort fallback, never for admin/
  accountant roles.
- **Step-up authentication:** require a fresh strong factor for **sensitive actions** —
  finalizing/refunding invoices, issuing credit notes, editing master rates, exporting bulk
  customer data, reopening a locked period, managing users.
- **MFA is mandatory** for every account that can touch finance, PII export, or admin —
  no exceptions, enforced server-side.

### 1.3 Passwords (only as a transitional/fallback factor)
- If passwords exist at all: **Argon2id** hashing, breach-list checks (k-anonymity HIBP),
  length ≥ 12, no forced rotation (NIST-style), lockout/backoff on brute force. Goal is to
  **retire passwords** in favour of passkeys.

### 1.4 Sessions
- Short-lived sessions, idle timeout (counter terminals shorter), absolute max lifetime,
  secure rotating tokens, **HttpOnly + Secure + SameSite** cookies, device/session list with
  remote revoke, re-auth for step-up. Bind sessions to a single origin.

---

## 2. Authorization (RBAC + least privilege)

- **Role-based access control** ([doc 02 §7]) with **least privilege** as default; permissions
  are granular (per action + per data scope, e.g. "own technician stock only").
- **Data scoping** so a technician's queries cannot return another technician's stock or
  customers they don't serve. On the primary DB (**MariaDB**) this is enforced in the
  **application/service layer plus scoped DB views** (a mandatory tenant/scope predicate
  injected by the repository layer, and views that pre-filter by the caller's scope). On
  engines that support it (PostgreSQL) the same predicate is additionally pushed down as native
  **row-level security** ([doc 04 §2.1]). Either way the guarantee is identical; scoping is
  also covered by automated tests (§6).
- **Segregation of duties:** the person who creates a refund/credit note shouldn't also be the
  sole approver above a threshold; bulk PII export gated to specific roles + step-up + audit.
- **No standing admin:** admin actions logged; consider time-boxed elevation.
- **Service-to-service** auth between microservices (mTLS / signed tokens); the fiscalization
  service's cert access is isolated ([doc 04 §4]).

---

## 3. Encryption & secrets

- **In transit:** TLS 1.2+ everywhere (1.3 preferred), HSTS, modern ciphers; **mTLS** to FURS
  and between internal services.
- **At rest:** full-disk/volume encryption **plus application-level encryption of PII columns**
  🔒 (customer contact data, IMEIs/serials, tax numbers, TOTP secrets) using authenticated
  encryption (AES-GCM / libsodium) with keys from a **KMS/HSM**, not in the codebase.
- **Secrets:** FURS private key, DB creds, API keys live in a **secrets manager** (Vault/cloud
  KMS); never in the repo, env files in images, or logs. **Rotate** on a schedule and on staff
  departure.
- **Key management:** documented rotation, separation of data-encryption keys vs key-encryption
  keys, access to keys audited.

---

## 4. Audit trail & tamper-evidence

- **Append-only `AuditEvent`** ([doc 03 §11]) for every create/modify/view-sensitive/export/
  auth event: actor, action, entity, before/after (PII redacted), IP, device, request id, time.
- **Immutable fiscal ledger** with optional **hash-chaining** ([doc 03 §6]) → silent
  back-dating or row insertion is detectable.
- Logs shipped to **write-once / restricted storage**; admins **cannot edit or delete** audit
  records. Retain audit logs in line with tax (10y) and security needs; review periodically.
- **Alerting** on anomalies: mass exports, off-hours admin actions, repeated MFA failures,
  PENDING_EOR backlog, cert expiry.

---

## 5. GDPR / ZVOP-2 programme

### 5.1 Roles & accountability
- kron.si is the **data controller**; cloud/hosting and the accounting/fiscal providers are
  **processors** → need **Data Processing Agreements (DPAs)** with each (Art. 28).
- Appoint a **person responsible for data protection** (a **DPO** if required by scale/
  activity; even if not strictly mandatory, assign clear ownership). Register with IP-RS as
  applicable under ZVOP-2.

### 5.2 Lawful basis & data minimisation (Art. 5–6)
| Data | Purpose | Lawful basis |
|------|---------|--------------|
| Customer contact + device + repair record | Perform the repair contract, warranty, invoicing | **Contract** + **legal obligation** (tax) |
| Invoice/accounting data | Statutory bookkeeping | **Legal obligation** (10-year retention) |
| Marketing emails/SMS | Promotions | **Consent** (separately captured, withdrawable) |
| Device contents seen during repair | Diagnose/repair only | **Contract**; strict minimisation, no copying beyond what's needed |
| Employee tax number (fiscal operator) | Legal fiscal requirement | **Legal obligation** |

- **Minimise:** collect only what's needed; don't store device unlock codes longer than the
  job; avoid imaging customer data; document any access to device contents.
- **Purpose limitation:** repair data is not silently reused for marketing.

### 5.3 Retention & erasure (the tension with tax law)
- **Accounting/invoice data must be kept 10 years** (real-estate 20y) — a **legal-obligation**
  basis that **overrides erasure requests** for that data. → Implement **field-level / tiered
  retention**: erase or pseudonymise **non-statutory** personal data (marketing prefs, free-
  text notes, contact details not needed for the kept invoice) on request or at end of purpose,
  while preserving the **legally required invoice record** (which can itself be minimised to
  the statutory fields).
- `gdpr_retention_until` per record; an automated **retention job** pseudonymises/erases
  expired non-statutory data and logs it.

### 5.4 Data-subject rights (Art. 15–22) — DSAR workflow
- Build a **DataRequest** workflow ([doc 03 §11]): access (export a subject's data —
  portability in machine-readable form), rectification, erasure (subject to §5.3),
  restriction, objection. Track deadlines (**1 month**, extendable), verify identity before
  fulfilling, log everything.

### 5.5 Records of Processing & DPIA (Art. 30/35)
- Maintain a **Record of Processing Activities (RoPA)**.
- Run a **DPIA** for higher-risk processing (e.g. accessing device contents, large customer
  datasets, any profiling in forecasting that touches individuals).

### 5.6 Breach response (Art. 33/34)
- Documented **incident-response plan**: detect → contain → assess → **notify IP-RS within 72
  hours** of becoming aware (if risk to individuals) → notify affected individuals if high
  risk → post-mortem. Keep a breach register. Run tabletop drills.

### 5.7 Privacy & security by design (Art. 25/32)
- Pseudonymise/encrypt PII, default to least exposure, build the above controls in from day one
  (this document), and **document** the technical & organisational measures (TOMs).

---

## 6. Application security (build practices)

- **OWASP ASVS** as the baseline; defend the **OWASP Top 10** (injection via parameterised
  queries/ORM, access-control tests per role, SSRF guards on outbound calls incl. FURS/VIES,
  secure deserialization of XML — **disable external entities/XXE** on e-SLOG/SOAP parsing).
- **Input validation & output encoding** everywhere; CSRF protection on state-changing
  endpoints; strict **CSP**, security headers.
- **Dependency & supply-chain hygiene:** SCA scanning, pinned versions, SBOM, signed builds,
  least-privilege CI, **no secrets in repo** (secret scanning in CI).
- **SAST/DAST** in CI; periodic **penetration test**, especially of the fiscalization service
  and auth.
- **Rate limiting & bot/abuse protection** on auth and public portal endpoints.
- **Tenant/data scoping tests** to prove a technician/customer cannot reach others' data.

---

## 7. Customer-facing portal (if/when built)

- Customers track repair status / approve estimates / view invoices. Same auth rigor:
  **passkeys offered**, magic-link or OTP as low-friction fallback, strict per-customer
  scoping, consent-aware notifications, and **no access to internal data**.

---

## 8. Backups, DR & business continuity

- **MariaDB point-in-time recovery** (binlog + `mariabackup`) + periodic full backups;
  **immutable/WORM** copy of the 10-year archive
  (PDF/XML/fiscal payloads) with object-lock so backups themselves can't be ransomware-encrypted
  or tampered.
- **Backups encrypted**, stored in the **EU**, access-controlled and audited.
- **Tested restores** (don't trust an untested backup); documented **RPO/RTO**; DR runbook.
- Continuity for the **48-hour FURS window**: the offline path ([doc 01 §3.6]) means a FURS or
  network outage doesn't stop you trading — but the **PENDING_EOR queue must survive a crash**
  (it's in a durable DB-backed queue) and be drained on recovery.

---

## 9. Physical & operational

- Shop terminals: auto-lock, no shared logins (each operator authenticates — needed anyway for
  the **operator tax number** on fiscal receipts, [doc 01 §3.8]), screen privacy.
- Technician mobile devices: device encryption, remote wipe (MDM), passkey/biometric unlock,
  scoped data only.
- Staff **onboarding/offboarding** checklist: provision least-privilege, **revoke on
  departure** (sessions, keys, secrets), security-awareness training.

---

## 10. Security & GDPR acceptance checklist

- [ ] Passkeys/WebAuthn live; MFA mandatory for finance/admin; SMS-OTP not used for privileged roles.
- [ ] Step-up auth on finalize/refund/credit-note/bulk-export/period-reopen/user-mgmt.
- [ ] RBAC + enforced data scoping (app layer + scoped views on MariaDB; RLS where supported); segregation of duties; no standing admin.
- [ ] PII encrypted at rest (column-level) + in transit (TLS/mTLS); secrets in KMS/HSM; rotation.
- [ ] Append-only audit + hash-chained immutable ledger; logs write-once; anomaly alerts.
- [ ] DPAs with all processors; RoPA maintained; DPO/owner assigned; IP-RS registration as needed.
- [ ] Lawful basis mapped; data minimised; marketing consent separate & withdrawable.
- [ ] Tiered retention: 10y statutory preserved, non-statutory PII erasable/pseudonymised.
- [ ] DSAR/erasure workflow with 1-month SLA + identity check.
- [ ] Breach plan with **72h** IP-RS notification; breach register; drills.
- [ ] DPIA done for device-content access & any individual-level profiling.
- [ ] OWASP ASVS baseline; XXE disabled on XML; SCA/SAST/DAST in CI; pen test scheduled.
- [ ] Encrypted EU-resident backups, WORM archive, **tested restores**, documented RPO/RTO.


---


<a id="doc06"></a>

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
- **Fiscalization service:** ZOI → EOR, QR/PDF417, **offline PENDING_EOR queue + 48h SLA**
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
- **DDV-O / PD-O** exports in eDavki-expected formats; period lock/close; AJPES annual-report
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
validated invoice → **ZOI/EOR/QR** with the 48h offline fallback, credit notes, immutable
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
| Numbering gaps under crash | Atomic allocation in finalize txn; recovery reconciliation; documented guarantee. |
| 48h EOR window missed in an outage | Durable DB-backed queue, drained on recovery, SLA alerting. |
| Wrong VAT treatment (rates/reverse charge/margin) | Rates & rules as validity-dated config; accountant sign-off; VIES at source. |
| Tax retention vs GDPR erasure conflict | Tiered/field-level retention; statutory data preserved, rest erasable ([doc 05 §5.3]). |
| Build effort underestimated | Consider buying fiscalization/e-SLOG; phase ruthlessly; MVP first. |
| PII breach | Encryption, RBAC+RLS, audit, 72h response plan, pen test. |


---


<a id="doc07"></a>

# 07 — Accounting Standards (Slovenia & EU)

You asked the ERP to fully comply with up-to-date **Slovenian and EU accounting standards**,
not just VAT/fiscal law. This chapter maps those standards to concrete ERP behaviour. As with
doc 01: **engineering interpretation, not accounting advice — confirm with the računovodja.**

## 1. The standards landscape

| Instrument | Role | Effect on us |
|------------|------|--------------|
| **ZGD-1** (Zakon o gospodarskih družbah / Companies Act) | Sets *who* must keep books, size classes, annual-report & filing duties. Transposes the EU Accounting Directive. | Determines reporting depth & AJPES filing. |
| **SRS 2024** (Slovenski računovodski standardi) | The national accounting standards, **in force since 1 Jan 2024** (4th revision; published Ur. l. RS 129/23). Detailed measurement/recognition guidance for entities using national standards. | The default rulebook for a typical SI SME like a repair shop. |
| **EU Accounting Directive 2013/34/EU** | EU framework behind ZGD-1/SRS; size thresholds, simplified regimes for micro/small. | Why SRS looks the way it does; size-based reporting. |
| **IFRS (as adopted by the EU)** | Mandatory only for specific entities (listed, banks, insurers, etc.); others may opt in. | A repair-shop SME normally uses **SRS, not IFRS**. SRS is kept *not materially in conflict* with IFRS, so IAS 2 (inventory), IAS 16 (PP&E), IFRS 15 (revenue) concepts are good mental models. |
| **Unified Chart of Accounts** (Enotni kontni okvir) | The standard account framework; companies derive their own chart from it. | Our GL mapping is built on it. |

### 1.1 Size classes (ZGD-1 / Directive) — they set reporting depth
Entities are **micro / small / medium / large** by thresholds on **net turnover, balance-sheet
total, average employees** (EU-harmonised, updated for inflation). A repair shop is most likely
**micro or small** → simplified annual report (balance sheet + income statement, abbreviated
notes), no statutory audit unless a threshold/criterion is met. **The ERP must hold the figures
that feed whichever class applies** and not assume a class — confirm current thresholds with the
accountant (they were raised EU-wide recently).

> **Design rule:** like VAT rates, **size thresholds and the chart of accounts are config**,
> validity-dated, never hard-coded.

## 2. Double-entry & the general ledger

- All business events post by **double-entry**. The ERP doesn't have to *be* the general
  ledger (the accountant's package often is), but it must **produce correct, mappable
  postings** for every economic event it owns.
- **Posting-rule engine** ([doc 02 §6.2], [doc 04 §6]): each document type → a configurable set
  of debit/credit lines against accounts from the **unified-chart-derived chart**. Examples:

| Event | Typical posting (illustrative — accountant confirms accounts) |
|-------|----------------------------------------------------------------|
| Sales invoice (22 %) | Dr Receivables / Cash · Cr Revenue · Cr Output VAT |
| Cash receipt | Dr Cash/Bank · Cr Receivables |
| Part consumed on repair | Dr COGS · Cr Inventory |
| Goods receipt (SI) | Dr Inventory · Cr Payables · Dr Input VAT |
| EU acquisition of parts | Dr Inventory · Cr Payables · Dr Input VAT · Cr Output VAT (reverse charge nets) |
| Credit note | reverse of the original, referencing it |
| Stock write-off (WEEE) | Dr Expense/Loss · Cr Inventory |
| Inventory revaluation to NRV | Dr Impairment expense · Cr Inventory allowance |

- **Mapping table** (`AccountMapping`) is admin-editable & validity-dated, so a chart change is
  config, not code.

## 3. Inventory — the standard that bites a parts business (SRS 4 / IAS 2)

Spare-parts stock is the ERP's biggest accounting surface, so get it right:

- **Measure at the lower of cost and net realisable value (NRV).**
- **Cost** = purchase price **+ import duties & non-recoverable taxes + freight-in & directly
  attributable acquisition costs**, **less** trade discounts/rebates ([doc 02 §3.3] landed
  cost). The ERP must roll all of these into the part's cost on goods receipt.
- **Cost-flow method:** **weighted average** or **FIFO** — chosen once, applied **consistently**
  (config in [doc 02 §5.4]/[doc 03 §7]). No LIFO. Same method per inventory category.
- **NRV write-downs:** obsolete/dead stock (old-model parts) is written down to NRV; the
  dead-stock/slow-mover report ([doc 02 §4]) feeds impairment decisions. Reversals allowed if
  NRV recovers (within original cost).
- **Perpetual inventory:** every `StockMovement` updates quantity *and* value → real-time COGS
  and inventory value, reconciled by periodic **stocktake** with documented variances.
- **Technician warehouses** are part of the same valued inventory — value doesn't leave the
  balance sheet on a transfer to a technician; it leaves (to COGS) only on **consumption**
  ([doc 02 §5.2]).

## 4. Revenue recognition (SRS 15/18 ≈ IFRS 15 concepts)

- Recognise **repair-service revenue when the service is performed** (job completed /
  control transferred), **parts revenue when handed over**. Aligns with the VAT tax point
  ([doc 01 §1.3]) but is a *separate* concept — keep `supply_date`/completion explicit.
- **Advances** are a **liability** until performance, not revenue ([doc 02 §2.2]).
- **Warranty:** a provision for expected repair-warranty cost may be required; track warranty
  claims to estimate it.

## 5. Receivables, payables, provisions, FX

- **Receivables:** age them; **allowance for doubtful/impaired** receivables per SRS; write-offs
  documented.
- **Payables** to suppliers tracked from PO→GR→invoice (3-way match, [doc 02 §3.3]).
- **FX:** non-EUR purchases/sales translated at the appropriate reference rate; period-end
  revaluation of open FX balances; exchange differences posted ([doc 04 §6] FX source).
- **Provisions/accruals** (e.g. warranty, WEEE/environmental fees) recognised when an
  obligation exists.

## 6. Fixed assets (if relevant) — SRS 1 / IAS 16

- Shop equipment, diagnostic tools, vehicles: a **fixed-asset register** with capitalisation
  threshold, **depreciation** (straight-line typical), useful lives, disposals. Likely a light
  module; the accountant may keep this — but the ERP should at least not lose the data.

## 7. Period close & annual reporting

- **Period locking** ([doc 03 §12]): once a VAT/accounting period is filed, documents into it
  are frozen; reopening is privileged & audited.
- **Year-end** produces the figures for the **annual report filed with AJPES** (balance sheet
  + income statement at the depth required by the size class), plus inventory valuation,
  COGS, receivables/payables ageing.
- **e-bookkeeping / digital records:** keep books and the **audit trail** in a form that is
  **authentic, integral, legible and reproducible for the full retention period**
  ([doc 01 §8], [doc 05 §8]) — append-only ledger + WORM archive satisfies this for both tax
  and accounting law.

## 8. What the ERP must export to the accountant

- **Journal/posting file** mapped to the chart of accounts (per §2).
- **Inventory valuation report** (qty × cost, by location & category, with NRV adjustments).
- **COGS** and **gross-margin** per period.
- **Receivables/payables** ledgers with ageing.
- **Fixed-asset & depreciation** schedule (if module used).
- **VAT books & returns** ([doc 01 §8]) — the tax side, cross-checked to the GL.
- A clean, **documented interchange** (standard format > bespoke CSV) so the external
  accountant's software ingests it without rekeying.

## 9. Accounting-compliance checklist

- [ ] Chart of accounts (unified-framework-derived) + validity-dated mapping table.
- [ ] Posting-rule engine produces balanced double-entry for every owned event.
- [ ] Inventory at lower of cost/NRV; landed cost captured; FIFO **or** weighted-avg, consistent.
- [ ] Perpetual inventory; technician transfers don't recognise COGS; consumption does.
- [ ] Dead-stock/NRV write-down workflow; reversals controlled.
- [ ] Revenue recognised on performance/handover; advances as liability; warranty provision.
- [ ] Receivables ageing + doubtful-debt allowance; payables 3-way match.
- [ ] FX translation + period-end revaluation.
- [ ] Size class & thresholds are config; annual-report figures available for AJPES.
- [ ] Period lock/close; records authentic/integral/legible for full retention.
- [ ] Standard, documented export to the accountant's software.

## Sources

- SRS 2024 (PISRS): https://pisrs.si/pregledPredpisa?id=DRUG5283 ·
  full text (gov.si PDF): https://www.gov.si/assets/ministrstva/MGTS/Dokumenti/DNT/Slovenski-racunovodski-standardi-2024.pdf
- Slovenian Institute of Auditors — SRS (2024): https://www.si-revizija.si/komisija-za-srs/srs-2024
- SRS 2024 in Uradni list RS: https://www.uradni-list.si/glasilo-uradni-list-rs/vsebina/2023-01-3897/slovenski-racunovodski-standardi-2024
- EU Accounting Directive 2013/34/EU (EUR-Lex): https://eur-lex.europa.eu/eli/dir/2013/34/oj/eng
- EC — guidance on Directive 2013/34/EU: https://finance.ec.europa.eu/publications/guidance-implementation-and-interpretation-directive-201334eu-accounting-rules_en
- The role/status of IFRS vs national rules in Slovenia (Accounting in Europe): https://www.tandfonline.com/doi/full/10.1080/17449480.2017.1300675


---


<a id="doc08"></a>

# 08 — UI / UX Design System ("servmod glass")

A complete, modern design language for the ERP: an **ultra-modern, Apple-inspired
"liquid-glass" aesthetic**, first-class **dark *and* light** themes, **tri-lingual UI
(Slovenian / English / German)**, and **everything configurable from the backend**. The goal
is a counter/technician tool that feels as polished as a consumer app while staying dense and
fast enough for real ERP work.

> **Two audiences, one system.** The *counter & admin* run on large screens with high data
> density; *technicians* work on phones/tablets in the field. The design system scales between
> them with the same tokens and components.

---

## 1. Design principles

1. **Clarity over decoration.** Glass and blur are used to establish hierarchy and depth, never
   to obscure data. Numbers, statuses and money are always crisp and high-contrast.
2. **Depth through translucency.** Layered, frosted "glass" surfaces (vibrancy/backdrop-blur)
   communicate stacking: background → content → cards → popovers → modals.
3. **Calm, focused color.** A neutral, desaturated base; color reserved for **state** (success/
   warning/danger/info) and a single brand accent.
4. **Fast & legible.** Sub-100ms interactions, motion that orients (not entertains), and text
   that stays readable on glass (we solve the classic "text on blur" contrast problem, §9).
5. **Consistent, tokenised, themeable.** Every visual value is a **design token**; themes and
   branding are **data the backend controls** (§10), not hard-coded CSS.
6. **Accessible by default.** WCAG 2.2 AA minimum — contrast, focus, motion-reduction, keyboard,
   screen-reader (§9). A repair shop serves everyone; so does the tool.

---

## 2. The "glass" aesthetic, done responsibly

The Apple-like look = **frosted, translucent panels floating over a soft, slightly blurred
background**, with thin light borders and gentle shadows.

- **Backdrop blur** on elevated surfaces: `backdrop-filter: blur(20–40px) saturate(160%)`.
- **Translucent fills:** light theme surfaces ≈ `rgba(255,255,255,0.6–0.75)`; dark theme ≈
  `rgba(22,22,28,0.55–0.7)`.
- **Hairline borders:** `1px` semi-transparent light border (top/left lighter to fake a light
  source) — the signature "glass edge".
- **Layered shadows:** soft, large-radius, low-opacity (`0 8px 32px rgba(0,0,0,.12)`), plus a
  subtle inner highlight on top edge.
- **Ambient background:** a quiet gradient / mesh with a few blurred color "blobs" that the
  glass refracts; **static or very slow** (respects reduced-motion).
- **Performance budget:** blur is GPU-expensive — cap the number of simultaneously blurred
  layers, fall back to solid translucent fills on low-power devices and when
  `prefers-reduced-transparency` is set, and never blur large scrolling tables (blur the
  *frame*, not the rows).

> **Guard rail:** glass is for **chrome and containers** (nav, cards, toolbars, modals,
> sidebars), not for dense data rows or printable documents. Invoices print on solid white
> (§11).

---

## 3. Theming: dark / light / auto (token-driven)

A **two-tier token system**:

- **Tier 1 — primitives** (raw palette): `--c-neutral-0…1000`, `--c-brand-…`, `--c-success/
  warning/danger/info-…`, blur radii, shadow steps, radii, space scale, type scale.
- **Tier 2 — semantic tokens** (what UI actually references), resolved per theme:
  `--bg-app`, `--bg-surface`, `--bg-surface-glass`, `--bg-elevated`, `--border-hairline`,
  `--text-primary`, `--text-secondary`, `--text-on-accent`, `--accent`, `--state-*`,
  `--shadow-1…4`, `--blur-panel`, `--focus-ring`.

Themes are just **different Tier-2 mappings**:

| Token | Light | Dark |
|-------|-------|------|
| `--bg-app` | warm near-white + ambient gradient | near-black `#0B0B0F` + ambient gradient |
| `--bg-surface-glass` | `rgba(255,255,255,.70)` | `rgba(28,28,34,.62)` |
| `--text-primary` | `#0C0C0F` | `#F5F6FA` |
| `--text-secondary` | `#3C3C43 @ 70%` | `#EBEBF5 @ 60%` |
| `--border-hairline` | `rgba(0,0,0,.08)` | `rgba(255,255,255,.12)` |
| `--accent` | brand (configurable) | brand (configurable, auto-lightened for dark) |

- **Switching:** `auto` (follows OS `prefers-color-scheme`), `light`, `dark` — per-user
  preference, persisted; instant, no reload (CSS variables on `:root[data-theme]`).
- **High-contrast theme** variant for accessibility, and a **"reduced transparency"** variant
  that swaps glass for solid surfaces (auto-enabled on `prefers-reduced-transparency`).
- Implementation: **CSS custom properties**; no theme logic baked into components. Works with
  Tailwind (CSS-var-backed theme), vanilla CSS, or any framework.

---

## 4. Color, state & status

- **Neutrals** carry the UI; **accent** (brand, default a calm blue/teal, backend-configurable)
  for primary actions and selection.
- **Semantic state colors** with paired *background/foreground/border* tokens, all AA-contrast
  in both themes: **success** (paid, verified), **warning** (PENDING_EOR, low stock, approaching
  Intrastat threshold), **danger** (overdue, failed fiscalization, errors), **info**, **neutral**.
- **Domain status palette** (consistent everywhere — tickets, invoices, stock): e.g. Ticket
  *Odprt / V delu / Čaka dele / Končan*, Invoice *Osnutek / Izdan / Potrjen (EOR) / Čaka EOR /
  Stornirano*, each a labelled **pill/badge** with icon + color (never color alone — §9).

---

## 5. Typography

- **UI font:** Inter (or the system stack: SF Pro / Segoe UI Variable / Roboto) — excellent at
  small sizes, full Latin-2 coverage for **Slovenian diacritics (č, š, ž)** and **German
  (ä, ö, ü, ß)**.
- **Numeric/money/IDs:** **tabular-figure** font (`font-variant-numeric: tabular-nums`, or a
  mono like JetBrains Mono) so columns of prices and invoice numbers align.
- **Type scale (rem):** 0.75 / 0.875 / 1 / 1.125 / 1.25 / 1.5 / 2 / 2.5; line-heights tuned for
  density. Clear weight hierarchy (400/500/600/700).
- **Long-word safety:** German compounds and Slovenian strings can be long → components must
  wrap/truncate gracefully (tooltips on truncation), never break layout (§8 i18n rule).

---

## 6. Spacing, radius, grid

- **4px base spacing scale** (4/8/12/16/24/32/48/64).
- **Radii:** controls 10px, cards 16–20px, modals 24px, pills full — the soft, rounded
  Apple feel.
- **Grid:** 12-col responsive; max content width on huge screens; **density toggle**
  (comfortable / compact) for data-heavy ERP tables, persisted per user.

---

## 7. Component library (the kit)

Built as a documented, reusable component set (Storybook or equivalent). Each component is
theme-aware, i18n-aware, accessible, and has loading/empty/error states.

- **Foundations:** GlassPanel/Card, Surface, Sheet/Modal, Popover, Tooltip, Toast, Drawer,
  Tabs, Accordion, Divider, Skeleton.
- **Navigation:** glass **Sidebar** (collapsible, icon+label), **Top bar / command bar** with
  global search + **⌘K command palette**, breadcrumbs, **theme switch**, **language switch**.
- **Inputs:** Text/Number/Currency (locale-aware, §8), Select/Combobox, MultiSelect, DatePicker
  (locale formats), Toggle, Checkbox/Radio, SegmentedControl, Slider, FileUpload,
  Search-with-scanner (barcode), Tax-rate picker, VAT-ID field (with VIES check state).
- **Data display:** **DataTable** (virtualised, sortable, filterable, column-config &
  density, saved views, CSV/XLSX export), KPI **StatCard**, Charts (revenue, margin, stock
  turnover, forecast), Timeline (ticket history/audit), DescriptionList, Status **Badge/Pill**,
  Money/Quantity formatters.
- **Domain widgets:** **Ticket card**, **Invoice editor** (line grid with live VAT/total
  recompute), **Fiscalization status chip** (ZOI present / EOR / PENDING_EOR with retry
  countdown), **Stock-by-location** view, **Technician warehouse** mobile panel,
  **Forecast suggestion** card, **Schedule builder** (for scheduled/collective invoices —
  [doc 09](#doc09)).
- **Feedback & system:** Confirmation dialogs with **step-up auth** prompt ([doc 05 §1.2]) for
  finalize/refund, inline validation, global error boundary, offline/connectivity banner
  (matters for the 48h FURS window).

### 7.1 Key screens
Dashboard (KPIs + today's tickets + alerts) · Tickets board & detail · **Invoice editor &
preview** · Invoices list (filter by status/period/fiscal state) · Customers · Parts catalogue
· **Stock & technician warehouses** · Purchasing/POs · **Forecasting** · **Scheduled &
collective invoices** ([doc 09]) · Reports/exports · **Settings/backend config** (§10) ·
Auth/passkey management ([doc 05]).

---

## 8. Internationalisation — SL / EN / DE (UI *and* documents)

**Every piece of text is localisable. Nothing is hard-coded.**

- **Three UI locales shipped: `sl` (default), `en`, `de`.** Architecture supports adding more
  with zero code change (locale = data).
- **Externalised strings:** ICU MessageFormat catalogues per locale (`sl.json`, `en.json`,
  `de.json`), with **pluralisation** (Slovenian has the tricky *one/two/few/other* plural
  rules — ICU handles `=1`, `=2`, `few`, `other`) and **gender/interpolation** support. No
  string concatenation in code.
- **Locale-aware formatting** via `Intl`: numbers (Slovenian uses `1.234,56` with comma
  decimal), **currency** (`1.234,56 €`), dates (`d. M. yyyy` SL vs `dd.MM.yyyy` DE vs `M/d/yyyy`
  EN), times, relative time. Money is **formatted at the edge**, stored as `DECIMAL`.
- **Language switcher** in the top bar; choice persisted per user; **independent of theme** and
  of the OS. Fallback chain `chosen → sl → key`.
- **Layout for translation:** components must tolerate **+40% text length** (German) and long
  Slovenian words without clipping; test all three locales in CI snapshots.
- **Diacritics & encoding:** UTF-8 end-to-end; fonts cover č/š/ž and ä/ö/ü/ß; collation/sorting
  uses locale-aware collation (e.g. correct Slovenian alphabetical order).
- **Content vs. chrome:** UI labels are translated; **user-entered data is shown as entered**
  (a part name typed in Slovenian stays Slovenian). Master data (part names, service
  descriptions, document legends) supports **per-locale translations** so an invoice can render
  its line descriptions in the document's chosen language (§11, [doc 09]).

---

## 9. Accessibility (WCAG 2.2 AA)

- **Contrast on glass is the #1 risk.** Enforce: text sits on a token (`--text-primary/
  -secondary`) guaranteed ≥ **4.5:1** against the *effective* (post-blur) surface; where blur
  can't guarantee it, add a subtle **scrim** behind text. Automated contrast tests in CI.
- **Respect user prefs:** `prefers-reduced-motion` (kill parallax/blur animation),
  `prefers-reduced-transparency` (solid surfaces), `prefers-contrast` (high-contrast theme),
  forced-colors/Windows high-contrast.
- **Never color-only:** status uses icon + label + color.
- **Keyboard & focus:** full keyboard nav, visible `--focus-ring`, logical order, focus trap in
  modals, skip links, ⌘K palette is keyboard-first.
- **Screen readers:** semantic HTML + ARIA, labelled inputs, live regions for toasts/validation,
  table semantics; localised `aria-label`s (tie into §8).
- **Targets:** ≥ 44×44px touch targets (technician mobile use).

---

## 10. Backend-configurable everything

A **Settings/Appearance** area (admin, audited — [doc 05 §4]) drives the look without deploys:

- **Branding:** company logo (light/dark variants), brand accent color (auto-derives the dark
  variant + hover/active states), favicon, login background, document letterhead/footer.
- **Theme defaults:** default theme (auto/light/dark), allow-user-override toggle, default
  density, default UI language, allowed languages.
- **Document/printout config:** per-document-type templates, which fields/columns show,
  legends/notes text **per locale**, paper size (A4 / thermal), logo placement, footer (bank/
  IBAN/registration), QR placement ([doc 01 §3.7]).
- **Domain config exposed to UI:** statuses & their colors/labels, tax rates ([doc 01 §1.1]),
  numbering series, business premises/devices, roles & permissions, dashboards/KPIs shown,
  email/SMS templates **per locale**, scheduled/collective-invoice rules ([doc 09]).
- **Mechanism:** config stored in DB, served as a typed **theme/config manifest** to the
  frontend (CSS variables hydrated at runtime), versioned & audited. Changing the accent or a
  legend is a config edit, not a code change. (This mirrors the doc-wide rule: *rates,
  thresholds, statuses, text → data, not code.*)

---

## 11. Print / PDF styling (localised invoices)

The on-screen glass UI and the **printed document are deliberately different render targets**
([doc 02 §2.6]):

- **Documents print on solid white**, high-contrast, no glass/blur — optimised for paper,
  thermal printers, and PDF/A archival (10-year retention, [doc 01 §8]).
- **Dedicated print stylesheet / PDF template** (can reuse the existing Smarty `printticket.tpl`
  layout + `$_language` dictionary, [doc 04 §1]) with: letterhead, all mandatory ZDDV-1 fields
  ([doc 01 §2]), VAT breakdown table, **ZOI/EOR + QR** for fiscalized docs, legends.
- **Printout localisation:** the document's language is **chosen per document** (default = the
  recipient/customer's language, configurable; SL/EN/DE), independent of the operator's UI
  language. Labels come from the per-locale document catalogue; **line descriptions** use the
  master-data per-locale translations (§8); money/dates formatted in that locale; the legal
  legends have an official Slovenian text that may be **accompanied** by a translation (the
  Slovenian legend is authoritative for SI tax purposes — confirm bilingual presentation with
  the accountant).
- **Consistent across channels:** the same template feeds the PDF, the printed receipt, and the
  customer-portal view; e-SLOG/EN 16931 ([doc 01 §7]) is the structured sibling of the same
  invoice object.

---

## 12. Tech & delivery notes

- **Tokens as the contract:** ship a `tokens.json` (Style-Dictionary-style) → generates CSS
  vars, and (if needed) native/print variants. Designers and devs share one source of truth.
- **Component docs:** Storybook with light/dark + all three locales as toggles; visual
  regression tests.
- **Framework-agnostic:** the token + CSS-var approach works whether the frontend stays
  server-rendered (Smarty/Blade) with progressive enhancement, or moves to a SPA (React/Vue/
  Svelte). Recommend a thin modern layer (e.g. **Vue or React + Tailwind bound to the tokens**)
  for the new ERP screens, embedded alongside the existing app.
- **Performance:** code-split, lazy-load heavy screens (forecasting/reports), virtualise long
  tables, cap blur layers (§2), prefetch on hover, optimistic UI for fast counter work.

---

## 13. UI/UX acceptance checklist
- [ ] Dark, light & auto themes; high-contrast & reduced-transparency variants; instant switch.
- [ ] Glass used only for chrome/containers; data rows & documents stay crisp/solid.
- [ ] Two-tier design tokens; zero hard-coded colors in components.
- [ ] Full component kit with loading/empty/error + all states, theme- & i18n-aware.
- [ ] SL/EN/DE UI via ICU catalogues; locale-aware number/currency/date; Slovenian plurals.
- [ ] Per-locale master-data & document text; **localised invoice printouts** (per-document language).
- [ ] WCAG 2.2 AA: contrast-on-glass enforced, reduced-motion/transparency respected, keyboard + SR.
- [ ] Backend-configurable branding, themes, statuses, document templates, languages, legends.
- [ ] Mobile/technician layouts (≥44px targets); density toggle for data screens.
- [ ] Print/PDF render target separate from UI; PDF/A-ready; ZOI/EOR/QR on fiscal docs.


---


<a id="doc09"></a>

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


---


<a id="doc10"></a>

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
  guard). Re-opened/edited tickets reconcile via the source ref.
- **Collective billing:** because Kayako time-tracks accumulate per ticket, the **collective
  invoice (zbirni račun, [doc 09])** is the natural monthly B2B document — sweep all billable
  tickets for a customer in the VAT period into one invoice.
- **Write-back:** push the resulting **invoice number + EOR + PDF link** back onto the Kayako
  ticket (a custom field/post) so staff see billing status where they already work.

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


---


<a id="doc11"></a>

# 11 — Outside-the-Box Features (high-value extensions)

You asked for ideas beyond the obvious ERP scope — features that make a repair business
faster, more profitable, more defensible, and delightful to use. Curated and prioritised;
each notes how it ties into the compliant core (docs 01–10). Treat this as a **product
backlog**, not all of it ships at once.

## A. Customer experience & front-of-house
1. **Self-service repair portal + status tracking** — live status ("diagnosing → awaiting
   parts → ready"), photos, **e-sign estimate approval** (the consent record, [doc 01 §9]),
   and **pay-online / payment link** before pickup. Localised SL/EN/DE ([doc 08 §8]).
2. **Omnichannel notifications** — SMS/Viber/WhatsApp/email, **two-way** ("Reply YES to
   approve the €X repair"), consent-aware ([doc 05 §5.2]). Drop-off & ready-for-pickup alerts.
3. **QR check-in kiosk** — walk-in customer scans a QR, describes the fault, signs the intake
   T&Cs, gets a ticket number + queue position. Feeds the device-condition record.
4. **Digital handover with signature + photos** — before/after photos and a signed
   condition report at intake and handover → **liability protection** and dispute defence.
5. **Loaner-device management** — track loaner phones/laptops issued during a repair (who has
   what, deposit, return), as serialized stock items ([doc 03 §7]).
6. **Appointment booking & queue** — online booking, capacity by technician/skill, reduces
   counter chaos; feeds **forecasting** ([doc 02 §4]).

## B. Diagnostics & repair intelligence
7. **IMEI/serial intelligence** — auto-identify device model, **warranty status**, blacklist/
   stolen check, original spec, via manufacturer/importer lookups (e.g. Apple GSX where
   authorised). Pre-fills the ticket and the right parts.
8. **Symptom → likely-part / likely-fix suggestions** — learned from your own ticket history
   (which faults consumed which parts) to suggest diagnosis, parts, and a quote — speeds
   estimates and **sharpens forecasting** ([doc 02 §4]).
9. **Repair knowledge base & guides** — per-model teardown notes, torque specs, common
   pitfalls, attached to the ticket; institutionalises senior techs' knowledge.
10. **Build-quality / re-repair analytics** — track **re-open / re-repair rate** per
    technician, part supplier, and device model → catch bad part batches and training needs.

## C. Money, margin & growth
11. **Trade-in / buyback with margin-scheme automation** — quote a buyback, grade the device,
    auto-apply the **second-hand margin scheme** ([doc 01 §4.4]) and its separate register.
12. **Care plans / subscriptions** — "device care" monthly plans billed via **recurring
    invoices** ([doc 09]); predictable revenue + retention.
13. **Dynamic, explainable pricing** — labour rates by complexity/urgency (express fee),
    parts margin guardrails, promo codes; all **backend-configurable** ([doc 08 §10]).
14. **Insurance & B2B fleet billing** — claim workflows for insurers and managed-device
    fleets, consolidated **collective invoices** ([doc 09]); warranty-payer billing
    ([doc 01 §4.5]).
15. **Profitability cockpit** — true margin per repair (labour + landed part cost + overhead),
    per technician, per device line; dead-stock cash tied up; forecast accuracy ([doc 07 §8]).

## D. Inventory & supply chain (beyond the basics in doc 02)
16. **Auto-PO & supplier price comparison** — forecasting raises **draft POs** automatically,
    compares supplier prices/lead times, and (optionally) EDI-submits ([doc 04 §6]).
17. **Warranty/RMA automation** — defective parts auto-open a supplier RMA; track credit owed
    back to you; reconcile against the customer-side warranty repair ([doc 02 §3.4]).
18. **Bin/shelf locations & pick paths** — sub-locations within a warehouse, barcode-guided
    picking; cycle-counting schedule instead of one painful annual stocktake.
19. **WEEE / battery / e-waste compliance dashboard** — quantities collected & disposed,
    environmental-fee reporting, certificates ([doc 01 §9]).

## E. Operations, AI & automation
20. **OCR supplier-invoice capture** — photograph/email a supplier invoice → parsed lines →
    3-way match ([doc 02 §3.3]); huge data-entry saving.
21. **Anomaly & fraud detection** — flag unusual cash patterns, voided receipts, stock
    shrinkage, off-hours admin actions ([doc 05 §4]) — protects against internal loss.
22. **Demand-forecasting ML** — upgrade the baseline forecaster ([doc 02 §4]) with seasonality
    + device-population trend models; keep suggestions **explainable**.
23. **Natural-language assistant (internal)** — "show overdue invoices for company X",
    "which model is trending in for screen repairs?" over the ERP data, **read-mostly**, with
    RBAC ([doc 05 §2]) — never bypassing the fiscal/ledger guarantees.
24. **Offline-first technician PWA** — bench/van app that works without signal, queues stock
    moves & labour, syncs later — pairs with the **48h FURS offline path** ([doc 01 §3.6]).

## F. Platform & ecosystem
25. **Open API + webhooks** — let ServiceApp ([doc 10]), the accountant's software ([doc 07
    §8]), and partners integrate cleanly; events like `invoice.fiscalized`,
    `stock.low`, `ticket.ready`.
26. **Multi-location / franchise mode** — multiple business premises & devices ([doc 01 §3.2]),
    per-location stock & reporting, central catalogue — scales kron.si to more shops.
27. **Embedded BI / scheduled report emails** — KPI dashboards and auto-emailed period reports
    to owners/accountant ([doc 07 §8]).
28. **Audit-grade "time machine"** — reconstruct any document/stock state at any past date from
    the append-only ledger + movements ([doc 03 §6]) — gold for inspections & disputes.

---

## Prioritisation (suggested)

| Tier | Ship when | Items |
|------|-----------|-------|
| **Quick wins** (high value, low effort, leans on the compliant core) | with Phases 1–3 ([doc 06]) | 1, 2, 4, 7, 11, 16, 20, 25 |
| **Differentiators** | Phases 4–6 | 5, 8, 10, 12, 14, 15, 17, 22, 26 |
| **Delight / advanced** | later | 3, 6, 9, 13, 18, 19, 21, 23, 24, 27, 28 |

> **Guard rail:** none of these may weaken the non-negotiables — gapless numbering, immutable
> fiscal ledger, real-time/48h FURS verification, VAT correctness, 10-year retention, and
> GDPR. Innovation lives **on top of** the compliant core, never around it.


---
