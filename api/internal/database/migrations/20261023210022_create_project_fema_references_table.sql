-- +goose Up
CREATE TABLE project_fema_references (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id bigint NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    sort_order integer NOT NULL DEFAULT 0,
    fema_map_number varchar(40) NOT NULL,
    fema_effective_date date NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    UNIQUE (project_id, fema_map_number)
);

-- +goose Down
DROP TABLE project_fema_references;