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

## Consequences

- The host distribution doesn't matter — only Podman needs to be installed on it.
- Each service needs its own port inside a pod.
- The same YAML format works on a Kubernetes cluster if one is ever needed.
- PostgreSQL data lives in a named Podman volume, which must be backed up.
