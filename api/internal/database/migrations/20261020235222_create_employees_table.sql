-- +goose Up
CREATE TYPE employee_position AS ENUM (
    'office_admin',
    'researcher',
    'cad',
    'field',
    'pls'
);

CREATE TABLE employees (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    auth_provider_user_id varchar(255) UNIQUE,
    name varchar(160) NOT NULL,
    email varchar(190) NOT NULL UNIQUE,
    position employee_position NOT NULL,
    initials varchar(3) NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX employees_position_idx ON employees (position);
CREATE INDEX employees_is_active_idx ON employees (is_active);

-- +goose Down
DROP TABLE employees;
DROP TYPE employee_position;
