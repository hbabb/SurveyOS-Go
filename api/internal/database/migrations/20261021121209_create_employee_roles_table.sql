-- +goose Up
CREATE TABLE employee_roles (
    employee_id bigint NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    role_id bigint NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (employee_id, role_id)
);

-- +goose Down
DROP TABLE employee_roles;
