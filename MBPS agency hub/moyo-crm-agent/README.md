# Moyo CRM Agent

A Cowork plugin for **Moyo Bespoke Property Solutions** that audits, organises, and reports on your Notion CRM with a single command.

---

## What it does

When triggered, the agent:

1. **Audits** every client, deal, and document in your Notion CRM for gaps and issues
2. **Spots stale deals** — any active deal with no activity in the past 14 days
3. **Auto-fixes** what it can directly in Notion (status updates, stale-deal flags, document escalation)
4. **Creates a health report page** inside your Notion CRM hub with a full breakdown
5. **Delivers a summary** in chat with your top priority actions and a link to the full report

---

## How to trigger it

Say any of the following in Cowork:

- "Review my CRM"
- "Audit the CRM"
- "CRM health check"
- "Organise my CRM"
- "Check my deals"
- "What's the state of my CRM?"
- "Is everything up to date?"

---

## What it checks

### Clients
- Missing email, phone, budget, target locations, or min yield
- Agreement not signed / deposit not paid
- Status not set

### Deals
- No linked client or documents
- Missing property address, sourcing fee, or target completion date
- Deposit not marked as received
- Stuck in a stage for 14+ days (stale)

### Documents
- Awaiting signature or stuck as draft for 14+ days
- No linked client or deal
- Missing file URL

---

## Auto-fixes applied

The agent makes these changes in Notion automatically:

| Fix | Condition |
|---|---|
| Flags stale deal in Notes | Active deal with no activity for 14+ days |
| Sets client Status to "Active" | Client has a live deal but Status is blank or "Prospect" |
| Escalates agreement from "Draft" to "Sent" | DSA is 14+ days old and a client is linked |

No records are ever deleted.

---

## Requirements

- Notion MCP connected and authenticated in Cowork
- Access to the Moyo Bespoke Property Solutions CRM workspace

---

## Version history

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | May 2026 | Initial release |
