-- +goose Up
CREATE TABLE project_field_crew (
    project_id bigint NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    employee_id bigint NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, employee_id)
);

CREATE INDEX idx_project_field_crew_employee_id ON project_field_crew (employee_id);

-- +goose Down
DROP TABLE project_field_crew;
