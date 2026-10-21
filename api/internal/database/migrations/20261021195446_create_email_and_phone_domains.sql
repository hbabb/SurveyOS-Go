-- +goose Up
CREATE DOMAIN email_address AS varchar(190)
    CHECK (
        VALUE ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
        AND VALUE = lower(VALUE)
        );

CREATE DOMAIN phone_number AS varchar(10)
    CHECK (
        VALUE ~ '^[0-9]{10}$'
        );

ALTER TABLE employees ALTER COLUMN email TYPE email_address;

-- +goose Down
ALTER TABLE employees ALTER COLUMN email TYPE varchar(190);

DROP DOMAIN email_address;
DROP DOMAIN phone_number;
