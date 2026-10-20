# ADR 0004: Authentication

- Status: Proposed — provider not chosen (Clerk or Kinde)
- Date: 2026-10-20

## Context

V1 users are GeoNexa staff only. There is no client portal in V1. The Civil 3D DLL also needs per-employee access to the API.

## Decision

### Staff login

- A hosted auth service handles staff login, password reset, and lockout.
- SurveyOS code only talks to it through an `auth` interface (for example, "who is the employee on this request"). Swapping providers, or moving to self-hosted auth, means writing a new implementation of that interface.
- `employees.id` is the key everything points to. The provider's user ID is stored separately in `employees.auth_provider_user_id` and is never a foreign key target.
- A request is rejected if the matching employee has `is_active = false`.

### Civil 3D access

- Each employee gets their own API tokens in `api_tokens`.
- Only a hash of each token is stored. The plain token is shown once, when it is created.
- Deactivating an employee revokes their tokens.
- All ten Civil 3D endpoints sit under `/api/v1/` behind the token check.

## Open

- Provider: Clerk or Kinde.
- How CAD gets its token: Option A (admin pastes a token into CAD) or Option B (login dialog in CAD). The token expiry policy depends on this.

## Consequences

- Login depends on the provider being reachable.
- Staff names and emails also exist at the provider.
