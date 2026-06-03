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
  [doc 09](09-scheduled-collective-invoicing.md)).
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
