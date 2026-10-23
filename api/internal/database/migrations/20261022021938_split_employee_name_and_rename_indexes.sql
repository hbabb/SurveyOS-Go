-- +goose Up
ALTER TABLE employees
    ADD COLUMN first_name varchar(100) NOT NULL,
    ADD COLUMN last_name varchar(100) NOT NULL,
    DROP COLUMN name;

ALTER INDEX employees_position_idx RENAME TO idx_employees_possition;
ALTER INDEX employees_is_active_idx RENAME TO idx_employees_is_active;

-- +goose Down
ALTER INDEX idx_employees_is_active RENAME TO employees_is_active_idx;
ALTER INDEX idx_employees_possition RENAME TO employees_position_idx;

ALTER TABLE employees
    ADD COLUMN name varchar(160) NOT NULL,
    DROP COLUMN first_name,
    DROP COLUMN last_name;
