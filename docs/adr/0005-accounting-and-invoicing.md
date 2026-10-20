# ADR 0005: Accounting and invoicing

- Status: Accepted
- Date: 2026-10-20

## Context

GeoNexa uses QuickBooks Online for accounting. SurveyOS needs invoices per project, and should be able to move off QuickBooks later without a rewrite.

## Decision

- **SurveyOS owns the invoice records**: `project_invoices` and `project_invoice_line_items`. QuickBooks receives a copy.
- QuickBooks sits behind an `accounting` interface with functions such as `PushInvoice`, `GetInvoicePDF`, and `GetPaymentStatus`. Only the QuickBooks implementation knows QuickBooks exists.
- Links to the accounting system use generic column names:
  - `companies.external_customer_id`
  - `contacts.external_customer_id` (individual clients)
  - `project_invoices.external_invoice_id`
- Payment is staff-marked in `project_invoices.paid_at`.
- Invoice follow-ups are logged in `project_invoice_followups`.

## Open

- Invoice PDFs: from QuickBooks, or from SurveyOS's own PDF generation.

## Consequences

- Moving off QuickBooks means a new implementation of the `accounting` interface, plus an invoice PDF template if QuickBooks was supplying the PDFs.
- No invoice data is lost if QuickBooks is removed.
