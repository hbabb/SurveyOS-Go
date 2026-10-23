-- +goose Up
CREATE TYPE account_status AS ENUM (
    'active',
    'inactive',
    'prospect',
    'suspended'
    );

CREATE TABLE companies (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(220) NOT NULL,
    account_status account_status NOT NULL DEFAULT 'active',
    main_email email_address UNIQUE,
    main_phone phone_number UNIQUE,
    accounting_email email_address UNIQUE,

    billing_address_line_1 varchar(255) NOT NULL,
    billing_address_line_2 varchar(255),
    billing_city varchar(120) NOT NULL,
    billing_state varchar(2) NOT NULL,
    billing_zip varchar(10) NOT NULL,

    physical_address_line_1 varchar(255),
    physical_address_line_2 varchar(255),
    physical_city varchar(120),
    physical_state varchar(2),
    physical_zip varchar(10),

    billing_notes text,
    notes text,
    restrict_contacts_to_assigned_projects boolean NOT NULL DEFAULT false,
    external_customer_id varchar(64),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_companies_name ON companies (name);
CREATE INDEX idx_companies_account_status ON companies (account_status);

-- +goose Down
DROP TABLE companies;
DROP TYPE account_status;
