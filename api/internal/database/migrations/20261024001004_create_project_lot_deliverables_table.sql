-- +goose Up
CREATE TYPE project_lot_deliverable_type AS ENUM (
    'lot_fit',
    'plot_plan',
    'house_stake',
    'pin_footings',
    'final_mortgage_survey'
    );

CREATE TABLE project_lot_deliverables (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_lot_id bigint NOT NULL REFERENCES project_lots(id) ON DELETE CASCADE,
    type project_lot_deliverable_type NOT NULL,
    date_ordered date,
    date_completed date,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    UNIQUE (project_lot_id, type),
    CHECK ( date_completed >= date_ordered )
);

-- +goose Down
DROP TABLE project_lot_deliverables;
DROP TYPE project_lot_deliverable_type;