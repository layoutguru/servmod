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
| **GDPR + ZVOP-2** | EU 2016/679 + Slovenian Personal Data Protection Act | Customer/employee personal data (see [doc 05](05-security-gdpr.md)). |

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
  [doc 03 §numbering](03-data-model.md) (DB sequence per premises+device, allocated inside the
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
  received. **This queue is mission-critical** — see [doc 04 §FURS service](04-architecture.md).

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
the (immutable) document — see [doc 03](03-data-model.md).

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
