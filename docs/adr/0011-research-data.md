# ADR 0011: Research data

- Status: Accepted
- Date: 2026-10-20

## Context

Research produces the ownership history, adjoiners, and documents that feed the plat and the Civil 3D title block.

## Decision

- A project has one or more subject parcels (`project_parcels`).
- Ownership chain: one `parcel_transfers` row per transfer, with grantor and grantee.
  - Deed book, deed page, and recorded date are required.
  - Plat book and page are optional, because ownership transfers by deed only.
  - A transfer can link to its source document.
- Adjoiners belong to a subject parcel (`project_adjoiners`).
- Research notes are dated and tied to the employee who wrote them.
- Documents (research and final deliverables) are stored in an S3-compatible bucket. The database stores only the object key and file details (`project_documents`).
- Parcel data from **Regrid** is fetched through the `parcels` interface.

## Consequences

- The full chain of title can be rebuilt per parcel, in recorded order.
- Files never live in the database.
