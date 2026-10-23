# ADR 0002: Tech stack

- Status: Accepted
- Date: 2026-10-20

## Context

SurveyOS is a business application for a small firm: forms, tables, statuses, PDFs, email, an audit trail, and a JSON API for Civil 3D. It should compile to something easy to deploy and be built from small, well-understood pieces.

## Decision

### Backend

- **Go.** Compiles to one binary. Type errors are caught at compile time.
- **chi** for routing. Built on `net/http`, so handlers stay standard Go. Route groups put the Civil 3D endpoints under `/api/v1/` behind the API token check.
- **testify** for test assertions on top of Go's `testing` package.
- **`html/template`** for email bodies.
- **`http.CrossOriginProtection`** for CSRF protection.

### Frontend

- **Vue** with **Vite+**.
- **Bun** as the package manager.
- **TypeScript**, so field names and types shared with the API are checked in the editor.
- **Vue Router** for screens.

### Database

- **PostgreSQL.**
- **goose** for migrations (versioned SQL files).
- **sqlc** to generate type-safe Go code from SQL queries.

### Tooling

- **mise** pins tool versions (Go, Bun, sqlc, goose) and holds project tasks.
- **Doppler** holds secrets (see ADR 0012).
- **jj** colocated with git. Remote: GitHub.

## Consequences

- Login, permissions, API tokens, and audit logging are written in SurveyOS rather than supplied by a framework. Each is a small amount of code (see ADRs 0004, 0006, 0007).
- Queries are plain SQL, checked against the schema by sqlc.
