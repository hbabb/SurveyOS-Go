# ADR 0003: Containers and hosting

- Status: Accepted
- Date: 2026-10-20

## Context

Development happens on Omarchy (Arch-based). The production server's distribution may differ. The environment must behave the same on both.

## Decision

- **Podman**, with services grouped in **pods** (containers that share one network and reach each other over `localhost`).
- One container per service:
  - Development pod: Go API, Vite dev server, PostgreSQL.
  - Production pod: Go API (serving the embedded frontend), PostgreSQL.
- Pods are defined in Kubernetes YAML (`deploy/*.kube.yaml`) and started with `podman kube play`.
- **Hosting:** GeoNexa's existing Hostinger VPS, running the production pod.
- No Kubernetes cluster. A single VPS covers GeoNexa's load.

### Development pod

`deploy/surveyos-dev.kube.yaml`:

- **postgres** — `postgres:18-alpine`. Data in the named volume `surveyos-dev-pgdata`, mounted at `/var/lib/postgresql` (the mount point for PostgreSQL 18+). Port 5432, published to `127.0.0.1` only.
- **web** — `oven/bun:1`, with `web/` bind-mounted at `/app`. Runs `bun install`, then the Vite+ dev server on port 5173, published to `127.0.0.1` only.
- **api** — added once the Go app exists.
- The database password comes from the Podman secret `surveyos-dev-db`. No secret values are in the file (see ADR 0012).
- The `web/` mount path is absolute (`/home/hqb/Projects/SurveyOS/web`). Moving the repo means updating it.

### Commands

- Start: `podman kube play deploy/surveyos-dev.kube.yaml`
- Recreate after changes: `podman kube play --replace deploy/surveyos-dev.kube.yaml`
- Stop: `podman kube play --down deploy/surveyos-dev.kube.yaml` (keeps the database volume)
- Stop and delete the database volume: add `--force`

## Consequences

- The host distribution doesn't matter — only Podman needs to be installed on it.
- Each service needs its own port inside a pod.
- The same YAML format works on a Kubernetes cluster if one is ever needed.
- PostgreSQL data lives in a named Podman volume, which must be backed up.
- PostgreSQL only reads `POSTGRES_PASSWORD` when it creates a new database. Changing the password later means changing it inside PostgreSQL, or recreating the volume.
