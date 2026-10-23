-- +goose Up
CREATE TYPE project_location_source AS ENUM (
    'geocoded',
    'manual'
    );

CREATE TABLE project_cad_setups (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id bigint NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,
    latitude decimal(10,7),
    longitude decimal(10,7),
    location_source project_location_source,
    geocoded_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),

    CHECK ( latitude BETWEEN -90 AND 90 ),
    CHECK ( longitude BETWEEN -180 AND 180 ),
    CHECK ( (latitude IS NULL) = (longitude IS NULL) )
);

-- +goose Down
DROP TABLE project_cad_setups;
DROP TYPE project_location_source;
