# SurveyOS

Practice management application for GeoNexa, a land surveying firm. Built by TechSolvd.

SurveyOS covers the firm's full workflow, from lead intake through research, field work, drafting, invoicing, delivery, and archive. It also serves the API used by the GeoNexa Civil 3D toolset.

> Developer-only grounding document. Not end-user documentation.

## Workflow

Lead → client added → site intake → proposal → acceptance → project activates → research → field / CAD → upload → CAD draft → draft and invoice sent → payment → final delivery → archive.

- Only an accepted proposal creates a project.
- A proposal can instead be a change order on an existing project.

## Stack

| Layer           | Choice                                              |
| --------------- | --------------------------------------------------- |
| Backend         | Go, chi (router), testify (tests)                   |
| Frontend        | Vue, Vite+, TypeScript, Vue Router                  |
| Package manager | Bun                                                 |
| Database        | PostgreSQL, goose (migrations), sqlc (queries)      |
| Containers      | Podman pods, one container per service              |
| Hosting         | GeoNexa's Hostinger VPS                             |
| Accounting      | QuickBooks Online, behind an interface              |
| Parcel data     | Regrid                                              |
| Geocoding       | Geocodio                                            |
| File storage    | S3-compatible bucket                                |
| CAD integration | C# .NET DLL (`GeoNexaToolPac_Cad.dll`) and AutoLISP |
| Version control | jj colocated with git, GitHub                       |
| Tool versions   | mise                                                |
| Secrets         | Doppler                                             |

## Repository layout

```
SurveyOS/
├── api/          Go backend
├── web/          Vue frontend
├── deploy/       Containerfile and Podman pod definitions
├── docs/
│   ├── adr/      Architecture decision records
│   └── schema/   SurveyOS.dbml
├── mise.toml     Tool versions and tasks for the whole repo
└── README.md
```

Full layout: [ADR 0001](docs/adr/0001-project-structure.md).

## Team

- Susie — office admin
- Lucas — researcher
- Chris — owner / PLS
- Sr. CAD technician — also IT / developer

## V1 scope

Included:

- Contacts, companies, and leads (`account_status = prospect`)
- Site intake, proposals, change orders, projects
- Field crew assignment and planned field date
- Survey details, CAD setup, FEMA references
- Subdivision lots and deliverables
- Research: subject parcels, ownership chain, adjoiners, research notes
- Documents in the S3-compatible bucket
- Invoices and invoice follow-ups
- Archive (locked + date, superuser unarchive)
- The ten Civil 3D endpoints

Not in V1:

- Client portal (proposals are accepted by email and logged by staff)
- Control points, plat notes / legend, plat items, impervious, field code check
- County links, deed extractor, lead follow-up log, time tracking, route planning, point clouds, login history

## Civil 3D endpoints

`titleblock`, `adjoiners`, `notes`, `plat-items`, `control`, `impervious`, `legend`, `research`, `project-center`, `field-code-check` — served under `/api/v1/`.

## Future features

- Client portal: online proposal acceptance, project status, deliverable downloads, invoice viewing, invoice payment
- Web map for research and project location data (control points, NGS monuments)
- Packaged self-hosted product or SaaS

## Decisions

All architecture decisions live in [`docs/adr/`](docs/adr/).

## License

Proprietary. © TechSolvd.
