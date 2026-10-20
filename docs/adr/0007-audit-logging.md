# ADR 0007: Audit logging

- Status: Accepted
- Date: 2026-10-20

## Context

GeoNexa needs a history of who changed what, across every part of the app.

## Decision

- One table, `activity_log`, records changes to any table.
- Each row holds the changed record (`subject_type`, `subject_id`), the employee who made the change (`causer_employee_id`, null for system actions), the event, a description, and the old and new values (`changes`, JSONB).
- The `audit` package writes these rows. Handlers call it in the same database transaction as the change itself, so a change is never saved without its log entry.
- No one-off history tables.

## Consequences

- Any table gets history without schema changes.
- `activity_log` grows over time; old rows may need archiving later.
