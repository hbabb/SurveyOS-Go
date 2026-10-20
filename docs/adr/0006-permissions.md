# ADR 0006: Permissions

- Status: Accepted
- Date: 2026-10-20

## Context

Staff access is role- and permission-based. An employee's job (`employees.position`) is not the same thing as what they're allowed to do.

## Decision

- Permissions live in SurveyOS's own database, not with the auth provider:
  - `roles`
  - `permissions`
  - `role_permissions` — which permissions each role grants
  - `employee_roles` — which roles each employee holds (more than one allowed)
- `employees.position` is descriptive only. It never grants access.
- Middleware checks the required permission before each protected handler runs.

## Consequences

- Changing auth providers doesn't touch permissions.
- The initial roles and permissions are seeded by migration.
