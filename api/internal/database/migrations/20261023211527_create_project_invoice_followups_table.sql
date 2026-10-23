-- +goose Up
CREATE TABLE project_invoice_followups (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id bigint NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    employee_id bigint NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    note text,
    followed_up_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_project_invoice_followups_project_id ON project_invoice_followups (project_id);
CREATE INDEX idx_project_invoice_followups_employee_id ON project_invoice_followups (employee_id);

-- +goose Down
DROP TABLE project_invoice_followups;
