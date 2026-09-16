# CRM Schema Reference

Complete field reference for the Moyo Bespoke Property Solutions Notion CRM.
Use this when reading or writing records so field names and option values are exact.

---

## 👥 Clients Database

**Database ID:** `dd631255-498a-429a-a559-edb795c1a624`
**Data Source:** `a5a5334f-95c5-4ebb-9ee2-99696648398c`

| Field | Type | Notes |
|---|---|---|
| Client Name | Title | Primary identifier |
| Client ID | Auto-increment | Prefix: CLT |
| Company | Rich text | Trading name / company |
| Email | Email | Contact email |
| Phone | Phone number | Contact phone |
| Address | Rich text | Full postal address |
| Client Type | Select | Investor · Developer · Buy-to-Let · HMO · Commercial · Serviced Accommodation |
| Status | Select | Active · Prospect · On Hold · Inactive · Completed |
| Investment Budget | Number (£) | Max purchase budget |
| Target Locations | Rich text | Areas / cities the client targets |
| Min Yield % | Number (%) | Minimum acceptable rental yield |
| Deposit Paid | Checkbox | True once £350 deposit cleared |
| Agreement Signed | Checkbox | True once DSA executed |
| Agreement Date | Date | Date DSA was signed |
| Notes | Rich text | Free-form notes |
| Date Added | Created time | Auto-set |
| Last Updated | Last edited time | Auto-set |

---

## 🤝 Deals Database

**Database ID:** `ae6e0140-7551-4d6e-bcb0-3d550580d972`
**Data Source:** `94caba1b-3c66-4005-bffc-43d17120cd19`

| Field | Type | Notes |
|---|---|---|
| Deal Name | Title | Descriptive deal name |
| Deal ID | Auto-increment | Prefix: DEAL |
| Client | Relation → Clients | Must always be linked |
| Stage | Select | See pipeline stages below |
| Priority | Select | High · Medium · Low |
| Property Address | Rich text | Full address of sourced property |
| Property Type | Select | Buy-to-Let · HMO · Commercial · Serviced Accommodation · Mixed Use · Land |
| Asking Price | Number (£) | Listed / agreed asking price |
| Monthly Rent | Number (£) | Confirmed or estimated monthly rent |
| Sourcing Fee | Number (£) | = 1 month's rent (auto-calculate when Monthly Rent is set) |
| Deposit Received | Checkbox | True once £350 deposit received from client |
| Deposit Amount | Number (£) | Should be 350 |
| Deposit Refund Due | Checkbox | Flag if refund is owed |
| Agreement Date | Date | Date sourcing agreement was signed |
| Target Completion | Date | Expected completion date |
| Actual Completion | Date | Actual completion date |
| Notes | Rich text | Progress notes and flags |
| Date Created | Created time | Auto-set |
| Last Updated | Last edited time | Auto-set — used for stale detection |

### Pipeline stages (in order)

1. Enquiry
2. Agreement Signed
3. Property Sourced
4. Offer Made
5. Due Diligence
6. Exchanged
7. Completed ← terminal
8. Fell Through ← terminal

Terminal stages (Completed, Fell Through) are excluded from stale-deal checks.

---

## 📄 Documents Database

**Database ID:** `9a818557-cd9f-4a9c-8d30-a897d2fba54b`
**Data Source:** `c46dd884-6a02-4932-a58b-aa227b818a0b`

| Field | Type | Notes |
|---|---|---|
| Document Name | Title | Descriptive name |
| Doc ID | Auto-increment | Prefix: DOC |
| Client | Relation → Clients | The client this document belongs to |
| Deal | Relation → Deals | The deal this document relates to |
| Document Type | Select | Deal Sourcing Agreement · Invoice · Company Let Agreement · Other |
| Status | Select | Draft · Sent · Awaiting Signature · Signed · Archived |
| Document Date | Date | Date the document was created or issued |
| File URL | URL | Link to the file (Google Drive, OneDrive, etc.) |
| Amount | Number (£) | For invoices: the amount invoiced |
| Notes | Rich text | Any relevant notes |
| Date Added | Created time | Auto-set |
| Last Updated | Last edited time | Auto-set |

---

## Stale Deal Definition

A deal is **stale** when ALL of the following are true:
- Stage is NOT "Completed" or "Fell Through"
- `Last Updated` is more than **14 days** before today's date

Use the `Last Updated` (last_edited_time) field for this calculation.
