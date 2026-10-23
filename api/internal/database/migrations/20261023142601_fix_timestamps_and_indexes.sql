-- +goose Up
ALTER TABLE employee_licenses
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

ALTER TABlE roles
ALTER COLUMN created_at SET NOT NULL,
ALTER COLUMN updated_at SET NOT NULL;

CREATE INDEX idx_api_tokens_employee_id ON api_tokens(employee_id);

ALTER INDEX idx_employees_possition RENAME TO idx_employees_position;

-- +goose Down
ALTER INDEX idx_employees_position RENAME TO idx_employees_possition;
DROP INDEX idx_api_tokens_employee_id;
ALTER TABLE roles
ALTER COLUMN created_at DROP NOT NULL,
ALTER COLUMN updated_at DROP NOT NULL;
ALTER TABLE employee_licenses
ALTER COLUMN created_at DROP NOT NULL,
ALTER COLUMN updated_at DROP NOT NULL;
