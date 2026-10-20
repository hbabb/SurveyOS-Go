# ADR 0008: Address storage

- Status: Accepted
- Date: 2026-10-20

## Context

Companies, individual clients, and site intakes all store addresses. GeoNexa works in the US only.

## Decision

- Addresses are stored as inline columns on the table that owns them, not in a separate addresses table.
  - `companies`: billing address (required) and physical address (optional).
  - `contacts`: billing address for individual clients (used only when `company_id` is null).
  - `site_intakes`: site address (optional; PIN required in app code when there's no address).
- US-only by design: no `country` column, `state` is a two-letter USPS abbreviation, `zip` holds ZIP or ZIP+4.

## Consequences

- Simple queries, no joins for addresses.
- Supporting non-US addresses later means adding columns and widening `state`.
