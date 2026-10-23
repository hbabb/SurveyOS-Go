-- +goose Up
CREATE TABLE project_lots (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id bigint NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    lot_number varchar(40) NOT NULL,
    house_plan varchar(120),
    homeowner_name varchar(220),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    UNIQUE (project_id, lot_number)
);

-- +goose Down
DROP TABLE project_lots;
