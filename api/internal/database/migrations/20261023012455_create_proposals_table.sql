-- +goose Up
CREATE TYPE proposal_status AS ENUM (
    'draft',
    'sent',
    'viewed',
    'accepted',
    'declined',
    'expired'
);

CREATE TYPE proposal_accepted_via AS ENUM (
    'portal',
    'employee_entry'
);

CREATE TABLE proposals (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    proposal_no varchar(8) NOT NULL UNIQUE,
    site_intake_id bigint NOT NULL REFERENCES site_intakes(id) ON DELETE RESTRICT,

    service_type_id bigint NOT NULL REFERENCES service_types(id) ON DELETE RESTRICT,
    scope_description text NOT NULL,
    exclusions_description text,
    fee_amount_cents bigint,

    status proposal_status NOT NULL DEFAULT 'draft',
    sent_at timestamp with time zone,
    viewed_at timestamp with time zone,
    accepted_at timestamp with time zone,
    accepted_via proposal_accepted_via,
    accepted_by_employee_id bigint REFERENCES employees(id) ON DELETE SET NULL,
    accepted_note text,
    accepted_ip_address inet,
    declined_at timestamp with time zone,
    declined_reason text,

    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),

    CHECK ( proposal_no ~ '^P-[0-9]{6}$' ),
    CHECK ( status <> 'accepted' OR accepted_at IS NOT NULL ),
    CHECK ( fee_amount_cents >= 0 ),
    CHECK ( status = 'draft' OR fee_amount_cents IS NOT NULL )
);

CREATE INDEX idx_proposals_site_intake_id ON proposals(site_intake_id);
CREATE INDEX idx_proposals_service_type_id ON proposals(service_type_id);
CREATE INDEX idx_proposals_status ON proposals(status);
CREATE INDEX idx_proposals_accepted_ip_address ON proposals(accepted_ip_address);

-- +goose Down
DROP TABLE proposals;
DROP TYPE proposal_accepted_via;
DROP TYPE proposal_status;
