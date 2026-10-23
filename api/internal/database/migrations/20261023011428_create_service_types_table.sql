-- +goose Up
CREATE TABLE service_types (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(140) NOT NULL,
    is_active boolean NOT NULL DEFAULT TRUE,
    created_at timestamp with time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp with time zone NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_service_types_name_lower ON service_types(lower(name));

-- +goose Down
DROP TABLE service_types;
