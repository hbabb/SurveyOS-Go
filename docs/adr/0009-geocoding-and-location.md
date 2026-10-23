# ADR 0009: Geocoding and location

- Status: Accepted
- Date: 2026-10-20

## Context

CAD setup needs a project location. Bad geocodes are worse than none.

## Decision

- Geocoding uses **Geocodio**, behind the `geocode` interface.
- Only rooftop-accuracy results are accepted.
- Geocoding is button-triggered on the CAD setup screen, not automatic at project creation.
- Coordinates are WGS84 latitude/longitude in `project_cad_setups`. No elevation is stored.
- A manual location always wins. Once `location_source = manual`, geocoding never overwrites it.
- Horizontal and vertical datums are covered in ADR 0014.

## Consequences

- Some projects have no coordinates until someone enters them manually.
