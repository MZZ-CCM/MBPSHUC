---
name: crm-review
description: >
  Audit, organise, and report on the Moyo Bespoke Property Solutions Notion CRM.
  Checks every client, deal, and document for gaps and stale records, auto-fixes
  what it can directly in Notion, then delivers a clean health report to both chat
  and a new Notion report page.
  Trigger when the user says: "review my CRM", "audit the CRM", "organise my CRM",
  "CRM health check", "check my deals", "what's the state of my CRM", "CRM report",
  "tidy up the CRM", "review deals", "check clients", "organise everything",
  "is everything up to date".
---

# CRM Review & Organisation Skill

Audit the Moyo Bespoke Property Solutions Notion CRM, auto-fix what can be fixed, create a Notion health report page, and output a concise chat summary.

## Database IDs (hardcoded — do not ask the user)

| Database    | Page/DB ID                               | Data Source ID                           |
|-------------|------------------------------------------|------------------------------------------|
| CRM Hub     | `366ba6e7-cc04-812f-bf7f-e012251eea6a`  | —                                        |
| Clients     | `dd631255-498a-429a-a559-edb795c1a624`  | `a5a5334f-95c5-4ebb-9ee2-99696648398c`  |
| Deals       | `ae6e0140-7551-4d6e-bcb0-3d550580d972`  | `94caba1b-3c66-4005-bffc-43d17120cd19`  |
| Documents   | `9a818557-cd9f-4a9c-8d30-a897d2fba54b`  | `c46dd884-6a02-4932-a58b-aa227b818a0b`  |

## Execution — follow these steps in order

### Step 1 — Fetch all records

Use `notion-fetch` on each of the three database URLs to retrieve all records and their properties. Note today's date for stale-deal calculations. The stale threshold is **14 days** (no activity on a non-terminal deal).

### Step 2 — Audit Clients

For each client record inspect the following. Log every issue under that client's name.

| Check | Condition that flags an issue |
|---|---|
| Missing email | Email field is blank |
| Missing phone | Phone field is blank |
| Missing investment budget | Investment Budget is blank |
| Missing target locations | Target Locations field is blank |
| Missing min yield | Min Yield % is blank |
| Deposit not marked paid | Deposit Paid = false AND client has at least one active deal |
| Agreement not signed | Agreement Signed = false |
| Status not set | Status field is blank |

### Step 3 — Audit Deals

For each deal record inspect the following. Log every issue under that deal's name.

| Check | Condition that flags an issue |
|---|---|
| No linked client | Client relation is empty |
| No linked documents | No Documents relation entries |
| Missing property address | Stage is "Property Sourced" or later AND Property Address is blank |
| Missing sourcing fee | Stage is "Offer Made" or later AND Sourcing Fee is blank |
| Deposit not received | Deposit Received = false |
| Missing target completion | Stage is "Due Diligence" or later AND Target Completion is blank |
| Stale deal | Last Updated > 14 days ago AND Stage is not "Completed" or "Fell Through" |

### Step 4 — Audit Documents

For each document record inspect the following.

| Check | Condition that flags an issue |
|---|---|
| No linked client | Client relation is empty |
| No linked deal | Deal relation is empty AND Document Type is "Deal Sourcing Agreement" or "Invoice" |
| Awaiting signature too long | Status = "Awaiting Signature" AND Document Date > 14 days ago |
| Draft too long | Status = "Draft" AND Document Date > 14 days ago |
| Missing file URL | File URL field is blank |

### Step 5 — Auto-fix in Notion

Perform ALL of the following fixes automatically using `notion-update-page`. Keep a running log of every change made for the report.

1. **Stale deal notes** — For every deal flagged as stale, append this to the Notes field (preserve existing text):
   `⚠️ Flagged as stale by CRM Review on [TODAY'S DATE] — no activity for 14+ days. Please update the stage or add a progress note.`

2. **Activate clients with live deals** — If a client's Status is blank or "Prospect" AND they have a deal at Stage "Agreement Signed" or beyond, set Status to "Active".

3. **Escalate long-draft agreements** — If a Deal Sourcing Agreement has Status "Draft" AND Document Date is older than 14 days AND a client is linked, update Status to "Sent" (assume it was sent if a deal exists).

Do not make any other changes to Notion records without explicitly asking the user first.

### Step 6 — Create Notion health report page

Create a new page inside the CRM Hub using `notion-create-pages` with parent page ID `366ba6e7-cc04-812f-bf7f-e012251eea6a`.

Page title: `📋 CRM Health Report — [TODAY'S DATE]`
Page icon: 📋

Structure the page content as follows:

```
> [Overall status callout]
> 🟢 CRM is healthy — no critical issues found.
> OR 🟡 CRM needs attention — [N] issues found across [X] records.
> OR 🔴 Action required — [N] issues found, including [most critical issue].
> Audit run: [TODAY'S DATE]  |  Stale threshold: 14 days

---

## 📊 Pipeline overview
[Table: Stage | Count | Notes]

---

## 👥 Client issues
[For each client with issues: client name as subheading, bulleted list of issues]
[If none: "✅ No client issues found."]

---

## 🤝 Deal issues
[For each deal with issues: deal name as subheading, bulleted list of issues]
[If none: "✅ No deal issues found."]

---

## 📄 Document issues
[For each document with issues: document name as subheading, bulleted list of issues]
[If none: "✅ No document issues found."]

---

## 🔧 Fixes applied
[Numbered list of every auto-fix made, e.g. "1. Updated Status to 'Active' for Dzimba Developers"]
[If none: "No automatic fixes were needed."]

---

## ✅ Recommended next actions
[Ordered list of the top priority actions the user should take, written as clear imperatives]
[Prioritise: missing agreements > unsigned documents > stale deals > missing contact info]
```

After creating the page, capture the returned page URL.

### Step 7 — Chat summary

Output a clean, scannable summary in chat. Keep it short — the full detail is in Notion.

Structure:
1. One-line overall status (🟢 / 🟡 / 🔴)
2. Issue count broken down: X client issues · Y deal issues · Z document issues
3. Auto-fixes applied: N fixes made (brief list)
4. Top 3 priority next actions as numbered bullets
5. Link to the full Notion report: [View full CRM Health Report](<page URL>)

If zero issues were found across all three databases, output: "Your CRM is in great shape ✅ — no gaps, no stale deals, all documents accounted for." Plus the Notion report link.

## Rules

- Never expose internal database IDs, collection URLs, or technical field names to the user
- Never delete records — only read and update
- If a Notion fetch fails, report the failure and continue with the remaining databases rather than stopping
- If unsure whether a field value counts as blank, treat null and empty string both as blank
- Phrase all issues as clear action items ("Dzimba Developers is missing a phone number") not technical field names ("Phone field is null")
