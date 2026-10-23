# ADR 0013: Database conventions

- Status: Accepted
- Date: 2026-10-22

## Context

The schema is built one migration at a time. Consistent naming and types keep it readable and searchable, and keep the app and the database agreeing on the rules.

## Decision

### Migrations

- goose, with timestamped file names (the default).
- One migration per table, created in workflow order so every referenced table exists first.
- File name: `create_<table>_table`.
- Every migration is tested with `up`, `down`, and `up` again before it's committed.
- One commit per migration: `feat(db): add <table> table`.
- A migration is never edited once pushed. Changes go in a new migration.

### Naming

- Tables: plural, snake_case (`site_intakes`).
- Indexes: `idx_<table>_<column>`, with columns joined by `_` for multi-column indexes (`idx_site_intakes_contact_id`).

### Types

- Primary keys: `bigint GENERATED ALWAYS AS IDENTITY`.
- Timestamps: `timestamp with time zone` (`timestamptz`).
- Tables holding editable data have `created_at` and `updated_at`.
- Link tables (`role_permissions`, `employee_roles`, `project_field_crew`) have no timestamps.
- Append-only tables (`api_tokens`, `activity_log`) have `created_at` only.
- Each enum is created in the migration of the first table that uses it, and dropped in that migration's Down section.

### Domains

Shared rules are defined once as PostgreSQL domains:

- `email_address` — `varchar(190)`, a basic email pattern, stored lowercase.
- `phone_number` — `varchar(10)`, exactly 10 digits. The app strips formatting before saving and adds `+1 (xxx) xxx-xxxx` for display.

### Validation

Rules are checked in both places: the app, for clear messages while the form is open, and the database, so bad data can't be saved by any path.

## Consequences

- Changing a shared rule means changing one domain, plus the matching app validation.
- Pushed migrations stay fixed, so every database built from the repo ends up the same.