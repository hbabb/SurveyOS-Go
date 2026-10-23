# ADR 0014: Title block data

- Status: Accepted
- Date: 2026-10-23

## Context

Each project's plat carries a title block: datums, scale, dates, and who drafted, checked, and surveyed it. CAD pulls this data from the API (see the `titleblock` endpoint). Free-text values for datums and scales lead to inconsistent title blocks.

## Decision

- Title block and survey data live in `project_survey_details`, one row per project.

### Datums and drawing scales

- Horizontal datum, vertical datum, and drawing scale are database enums: `project_horizontal_datum`, `project_vertical_datum`, and `project_drawing_scale`. This replaces the earlier plan to keep datums as application-level picklists.
- New values only ever get added. Old projects keep the datum and scale they were drawn with, so no value is ever removed.
- Defaults: horizontal `NAD83 (NSRS 2011)`, vertical `NAVD88 (GEOID18)`.
- Scale values are written as they appear on the plat, such as `1" = 20'`.

### Initials

- `DRAFTED BY:` and `CHECKED BY:` come from `drafter_id` and `checker_id`. `FIELD CREW:` comes from `project_field_crew`.
- The title block shows each employee's `initials`, looked up by a query. Initials are not stored on the project, so a correction in `employees` reaches every title block.

### Field drafting

- `drafted_in_field` is true when the field crew chief ran Field-to-Finish and started the drawing on site. Those projects still enter the `ready_for_drafting` queue, but CAD does a QA and labeling pass instead of a full draft.

## Consequences

- An invalid datum or scale can't be saved by any path.
- Adding a datum or scale is a one-line migration.
