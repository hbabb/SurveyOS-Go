# ADR 0010: Proposal and project lifecycle

- Status: Accepted
- Date: 2026-10-20

## Context

GeoNexa should never have projects for jobs it didn't win, and every project must trace back to what the client agreed to.

## Decision

### Leads and intake

- A lead is a contact or company with `account_status = prospect`. There is no separate leads table.
- Site intake comes first: city, county, and state required; address optional; PIN required in app code when there's no address; township optional; notes for things like gate codes.

### Proposals

- A proposal points to a site intake instead of copying address data.
- Holds scope, exclusions, fee, status, and the acceptance timestamps.
- Proposal number `P-YYNNNN` is generated when the proposal is created.
- V1: clients accept by email (staff-generated PDF). Staff logs the acceptance with a note (`accepted_via = employee_entry`).
- Acceptance checks the typed name and email against the contact on file.

### Projects

- A project is created only when a proposal is accepted.
- Project number `YYNNNN` is generated at acceptance.
- One project per original proposal (`projects.proposal_id` is unique).
- A change order is a proposal with `change_order_project_id` set. It reuses the project's site intake and gets a normal `P-YYNNNN` number. A project can have many change orders.
- Status is two-way: no enforced forward-only transitions.
- `priority` is null by default and overrides the computed research/CAD queue order.
- The research/CAD queue is computed (first in, first out, with priority override), not stored.
- Field crew is a link table (`project_field_crew`).
- Archive sets `archived_at` and locks the project. Only a superuser can unarchive.

### Subdivisions

- Builder subdivision projects get `project_lots` (lot number, house plan, homeowner name for the title block).
- Homeowners are not contacts and have no portal access.
- Each lot has up to five deliverables: lot fit, plot plan, house stake, pin footings, final mortgage survey. Each tracks only `date_ordered` and `date_completed`.

## Open

- Whether a name/email mismatch at acceptance blocks it or flags it for staff review.

## Consequences

- No phantom projects.
- Change orders share the project's history and site.
