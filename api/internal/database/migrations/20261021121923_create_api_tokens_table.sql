-- +goose Up
CREATE TABLE api_tokens (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id bigint NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    name varchar(120) NOT NULL,
    token_hash varchar(255) NOT NULL UNIQUE,
    last_used_at timestamp with time zone,
    expires_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

-- +goose Down
DROP TABLE api_tokens;
