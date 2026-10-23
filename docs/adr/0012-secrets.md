# ADR 0012: Secrets

- Status: Accepted
- Date: 2026-10-20

## Context

SurveyOS needs secrets: the database password now, and later API keys (QuickBooks, Regrid, Geocodio, the auth provider, storage, email). None of them may be committed to the repository — including in development, and including base64-encoded values, which are an encoding, not encryption.

## Decision

- **Doppler** is the source of truth for every secret, with separate configs for development and production.
- The repo is linked to Doppler with `doppler setup`. Commands that need secrets run through `doppler run -- <command>`, which passes the secrets in as environment variables.
- Pod files contain no secret values. They reference **Podman secrets** by name.

### Database password

- Stored in Doppler as `DB_PASSWORD`.
- Copied into the Podman secret `surveyos-dev-db` (development) before the pod starts:

  ```
  printf '{"password":"%s"}' "$(doppler secrets get DB_PASSWORD --plain | base64 -w0)" | podman secret create --replace surveyos-dev-db -
  ```

  - `podman kube play` reads a Podman secret as JSON (or Kubernetes Secret YAML) and decodes each value from base64 once. The value is base64-encoded here so it decodes back to exactly the Doppler password.
  - The `password` key matches `key: password` in the pod file.

- Production follows the same pattern on the VPS, with its own Doppler config and secret name.

## Open

- Whether the database user and database name also move out of the pod file into Doppler and the Podman secret.
- Podman's default secret storage is not encrypted: an owner-only file at `~/.local/share/containers/storage/secrets/filedriver/secretsdata.json`. Podman's `pass` driver stores secrets GPG-encrypted; whether it works with `podman kube play` hasn't been checked.

## Consequences

- No secret is in the repository or its future history.
- Each machine running a pod needs the Doppler CLI and access to the right config.
- After the Doppler password changes, the Podman secret must be recreated, and PostgreSQL's password changed to match.
