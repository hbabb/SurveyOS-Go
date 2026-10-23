-- +goose Up
CREATE TABLE activity_log (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subject_type varchar(100),
    subject_id bigint,
    causer_employee_id bigint REFERENCES employees(id) ON DELETE SET NULL,
    event varchar(40),
    description text NOT NULL,
    changes jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_activity_log_subject ON activity_log (subject_type, subject_id);
CREATE INDEX idx_activity_log_causer_employee_id ON activity_log (causer_employee_id);

-- +goose Down
DROP TABLE activity_log;
