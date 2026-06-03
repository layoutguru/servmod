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
- **Row-level security in PostgreSQL** to enforce scoping at the DB (a technician's queries
  cannot return another technician's stock or customers they don't serve).
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

- **PostgreSQL PITR** + periodic full backups; **immutable/WORM** copy of the 10-year archive
  (PDF/XML/fiscal payloads) with object-lock so backups themselves can't be ransomware-encrypted
  or tampered.
- **Backups encrypted**, stored in the **EU**, access-controlled and audited.
- **Tested restores** (don't trust an untested backup); documented **RPO/RTO**; DR runbook.
- Continuity for the **48-hour FURS window**: the offline path ([doc 01 §3.6]) means a FURS or
  network outage doesn't stop you trading — but the **PENDING_EOR queue must survive a crash**
  (it's in durable Postgres) and be drained on recovery.

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
- [ ] RBAC + Postgres row-level security; segregation of duties; no standing admin.
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
