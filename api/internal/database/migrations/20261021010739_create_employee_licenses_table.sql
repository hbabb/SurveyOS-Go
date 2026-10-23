-- +goose Up
CREATE TABLE employee_licenses (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id bigint NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    state varchar(2) NOT NULL,
    license_number varchar(40) NOT NULL,
    UNIQUE (employee_id, state),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- +goose Down
DROP TABLE employee_licenses;
