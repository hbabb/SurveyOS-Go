-- +goose Up
CREATE TYPE contact_role AS ENUM (
    'project_manager',
    'accounting',
    'title_agent',
    'realtor',
    'attorney',
    'lender',
    'property_owner'
);

CREATE TABLE contacts (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id bigint REFERENCES companies(id) ON DELETE SET NULL,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email email_address NOT NULL UNIQUE,
    phone phone_number NOT NULL,
    title varchar(160),
    contact_role contact_role,
    account_status account_status,
    portal_enabled boolean NOT NULL DEFAULT false,
    notification_email email_address,
    can_view_accounting boolean NOT NULL DEFAULT false,
    can_view_all_company_projects boolean NOT NULL DEFAULT false,

    address_line_1 varchar(255),
    address_line_2 varchar(255),
    city varchar(120),
    state varchar(2),
    zip varchar(10),

    notes text,
    external_customer_id varchar(64),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_contacts_company_id ON contacts (company_id);

-- +goose Down
DROP TABLE contacts;
DROP TYPE contact_role;
