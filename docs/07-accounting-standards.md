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
