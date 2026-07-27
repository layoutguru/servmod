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
    moves & labour, syncs later — pairs with the **two-working-day FURS offline path** ([doc 01 §3.6]).

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
> fiscal ledger, real-time/two-working-day FURS verification, VAT correctness, 10-year retention, and
> GDPR. Innovation lives **on top of** the compliant core, never around it.
