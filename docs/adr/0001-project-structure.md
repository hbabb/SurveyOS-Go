# ADR 0001: Project structure

- Status: Accepted
- Date: 2026-10-20

## Context

SurveyOS has a Go backend, a Vue frontend, a PostgreSQL database, and runs in Podman containers. One repository holds all of it so the schema, API, and frontend change together.

## Decision

One repository, with the backend and frontend in separate top-level folders.

```
SurveyOS/
├── api/
│   ├── cmd/
│   │   └── surveyos/
│   │       └── main.go            Entry point: config, database, router, server
│   ├── internal/
│   │   ├── config/                Environment variables → typed config
│   │   ├── database/
│   │   │   ├── migrations/        goose migration files (*.sql)
│   │   │   ├── queries/           sqlc query files (*.sql)
│   │   │   └── sqlc/              sqlc-generated Go code (never hand-edited)
│   │   ├── server/
│   │   │   ├── router.go          chi routes
│   │   │   └── middleware/        Auth, API tokens, permissions, CSRF, logging
│   │   ├── handlers/              One file per resource (projects, proposals, …)
│   │   ├── cad/                   The ten Civil 3D endpoints (/api/v1/)
│   │   ├── auth/                  Auth interface + hosted provider implementation
│   │   ├── accounting/            Accounting interface + QuickBooks implementation
│   │   ├── audit/                 Writes activity_log rows
│   │   ├── numbering/             P-YYNNNN and YYNNNN generation
│   │   ├── geocode/               Geocodio client
│   │   ├── parcels/               Regrid client
│   │   ├── storage/               S3-compatible bucket client
│   │   ├── email/                 Email sending + html/template bodies
│   │   └── webui/
│   │       ├── embed.go           go:embed of the built frontend
│   │       └── dist/              Copied from web/dist at build time (git-ignored)
│   ├── go.mod
│   ├── go.sum
│   └── sqlc.yaml
├── web/
│   ├── src/
│   │   ├── api/                   Typed fetch functions for the Go API
│   │   ├── components/
│   │   ├── views/                 One view per screen
│   │   ├── router/                Vue Router
│   │   ├── types/                 Shared TypeScript types
│   │   ├── App.vue
│   │   └── main.ts
│   ├── index.html
│   ├── package.json
│   ├── bun.lock
│   ├── tsconfig.json
│   └── vite.config.ts             Dev proxy: /api → Go API container
├── deploy/
│   ├── api.Containerfile
│   ├── web.Containerfile          Dev-only Vite server
│   ├── surveyos-dev.kube.yaml     Dev pod: api, web, postgres
│   └── surveyos-prod.kube.yaml    Production pod: api, postgres
├── docs/
│   ├── adr/
│   └── schema/
│       └── SurveyOS.dbml
├── mise.toml
├── .gitignore
└── README.md
```

### Rules

- `api/` is its own Go module. `web/` is its own Bun project, built with Vite+.
- `api/internal/` keeps packages private to SurveyOS.
- Each outside service (`accounting`, `auth`, `geocode`, `parcels`, `storage`, `email`) sits behind a Go interface, so the provider can be swapped without touching handlers.
- One `mise.toml`, at the root. It applies to `api/` and `web/` automatically.
- `docs/schema/SurveyOS.dbml` is the schema source of truth. Migrations follow it.

### Frontend embedding

`go:embed` cannot reach parent directories, so it cannot read `web/dist` from inside `api/`. The production build copies `web/dist` into `api/internal/webui/dist`, then compiles the Go binary. The result is one binary serving both the API and the frontend.

In development, the Vite dev server runs in its own container and proxies `/api` requests to the Go API container.

## Consequences

- Schema, API, and frontend changes land in the same commit.
- The Go binary has no runtime dependency on Node in production.
- The copy step must run before every production build. It lives in a `mise` task so it cannot be skipped.
