-- +goose Up
CREATE TYPE project_status as ENUM (
    'research',
    'ready_for_schedule',
    'scheduled',
    'ready_for_drafting',
    'ready_for_review',
    'ready_for_invoice',
    'awaiting_payment',
    'ready_to_deliver',
    'delivered'
);

CREATE TYPE project_priority AS ENUM (
    'high',
    'urgent'
);

CREATE TYPE project_customer_status AS ENUM (
    'project_started',
    'project_delayed',
    'draft_ready',
    'final_ready'
    );

CREATE TABLE projects (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_no varchar(6) NOT NULL UNIQUE,
    project_name varchar(220) NOT NULL,
    proposal_id bigint NOT NULL UNIQUE REFERENCES proposals(id) ON DELETE RESTRICT,

    status project_status NOT NULL DEFAULT 'research',
    status_changed_at timestamp with time zone,
    priority project_priority,

    field_scheduled_date date,
    invoiced_at timestamp with time zone,
    last_followed_up_at timestamp with time zone,
    customer_status project_customer_status NOT NULL DEFAULT 'project_started',
    customer_status_notes text,
    target_delivery date,

    project_manager_id bigint REFERENCES employees(id) ON DELETE SET NULL,
    researcher_id bigint REFERENCES employees(id) ON DELETE SET NULL,

    is_active boolean NOT NULL DEFAULT TRUE,
    archived_at timestamp with time zone,

    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW(),

    CHECK ( project_no ~ '^[0-9]{6}$' )
);

CREATE INDEX idx_projects_status ON projects (status);
CREATE INDEX idx_projects_status_last_followed_up_at ON projects (status, last_followed_up_at);

-- +goose Down
DROP TABLE projects;
DROP TYPE project_customer_status;
DROP TYPE project_priority;
DROP TYPE project_status;
