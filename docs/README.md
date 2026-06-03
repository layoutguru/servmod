# servmod ERP — Design & Compliance Plan

A comprehensive design for a fully Slovenia-compliant ERP for a **device-repair business**
(kron.si), covering invoicing, credit notes, **scheduled/recurring & collective invoices
(zbirni račun)**, parts ordering & forecasting, stock, per-technician "warehouses", exports,
and the legal machinery (VAT / ZDDV-1, fiscal verification / ZDavPR, e-invoicing) that wraps
around all of it — with a strong emphasis on **GDPR, data security, passkeys and 2FA**, a
modern **dark/light "Apple-glass" UI** localised in **Slovenian / English / German**, and
**MariaDB** (with a portable abstraction for other modern databases).

> ⚠️ **Not legal/tax advice.** This document is an engineering design grounded in public
> sources (FURS technical documentation, ZDDV-1, ZDavPR, SPOT/EU guidance). Slovenian tax
> law changes frequently; before go-live, **every rate, threshold, deadline and report
> format in here must be confirmed with the company's accountant (računovodja) and against
> the current FURS technical specification.** Citations are listed in
> [§ Sources](01-legal-compliance-slovenia.md#sources).

## How to read this plan

| # | Document | What it answers |
|---|----------|-----------------|
| 01 | [Legal & compliance analysis (Slovenia)](01-legal-compliance-slovenia.md) | VAT rates & rules, what a legal invoice/credit note must contain, **FURS fiscal verification** (ZOI/EOR), reverse charge, margin scheme, EU trade reporting, e-invoicing, retention. |
| 07 | [Accounting standards (SI & EU)](07-accounting-standards.md) | **SRS 2024**, EU Accounting Directive 2013/34/EU, IFRS scope, double-entry posting, inventory valuation (cost/NRV, FIFO/weighted-avg), revenue recognition, AJPES reporting. |
| 02 | [ERP functional design](02-erp-functional-design.md) | Repair workflow → documents. Invoices, credit notes, advances, parts orders, forecasting, stock & technician warehouses, exports/reporting. |
| 03 | [Data model](03-data-model.md) | Entities, relationships, key tables, the immutable fiscal ledger, numbering. |
| 04 | [Architecture & integrations](04-architecture.md) | Tech stack, how it bolts onto the existing servmod/Smarty ticketing app, the **FURS fiscalization microservice**, e-SLOG, accounting & supplier integrations. |
| 05 | [Security & GDPR](05-security-gdpr.md) | **Passkeys/WebAuthn, 2FA/MFA**, RBAC, encryption, audit trail, GDPR (RoPA, retention, DSAR, breach), backups & DR. |
| 08 | [UI / UX design system](08-ui-design-system.md) | Modern **dark/light "Apple-glass"** design language, tokens, component kit, **SL/EN/DE** i18n (UI + localised printouts), accessibility, **fully backend-configurable** theming. |
| 09 | [Scheduled, recurring & collective invoices](09-scheduled-collective-invoicing.md) | **Scheduled/deferred** invoices, **recurring** (contracts), **collective/zbirni račun** — legal basis, fiscal-verification rules, scheduler architecture. |
| 10 | [ServiceApp integration & billing migration](10-serviceapp-integration-billing.md) | Bridging the existing **Kayako-based ServiceApp** into the ERP: billing-data mapping, migration strategy, and exactly what's needed from the DB dump. |
| 11 | [Outside-the-box features](11-outside-the-box-features.md) | High-value extensions — portal, trade-in/margin, care plans, IMEI/warranty lookup, OCR, ML forecasting, fraud detection, open API, franchise mode. |
| 06 | [Delivery roadmap](06-roadmap.md) | Phased plan, milestones, risks, MVP cut. |

## The shape of the problem (one paragraph)

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

Start with **[01 — Legal & compliance analysis](01-legal-compliance-slovenia.md)**; the rest
of the design is built to satisfy it.
