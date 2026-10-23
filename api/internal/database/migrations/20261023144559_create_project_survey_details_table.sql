-- +goose Up
CREATE TYPE project_horizontal_datum AS ENUM (
    'NAD27',
    'NAD83 (NSRS 2011)',
    'WGS84'
    );

CREATE TYPE project_vertical_datum AS ENUM (
    'NGVD29',
    'NAVD88 (GEOID18)'
    );

CREATE TYPE project_drawing_scale AS ENUM (
    '1" = 1''',
    '1" = 5''',
    '1" = 10''',
    '1" = 20''',
    '1" = 30''',
    '1" = 40''',
    '1" = 50''',
    '1" = 60''',
    '1" = 70''',
    '1" = 80''',
    '1" = 100''',
    '1" = 200''',
    '1" = 300''',
    '1" = 400'''
    );

CREATE TABLE project_survey_details (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_id bigint NOT NULL UNIQUE REFERENCES projects(id) ON DELETE CASCADE,

    drawing_title varchar(220),
    ordered_by_name varchar(190),

    zoning_district varchar(60),
    setback_front_ft numeric(6,2),
    setback_side_ft numeric(6,2),
    setback_rear_ft numeric(6,2),
    setback_notes text,

    ngs_monument_name varchar(80),
    ngs_combined_scale_factor numeric(10,8),
    horizontal_datum project_horizontal_datum NOT NULL DEFAULT 'NAD83 (NSRS 2011)',
    vertical_datum project_vertical_datum NOT NULL DEFAULT 'NAVD88 (GEOID18)',
    basis_of_bearing text,
    benchmark_description varchar(190),

    certifying_surveyor_id bigint REFERENCES employees(id) ON DELETE SET NULL,
    field_date date,
    survey_date date,
    draft_date date,
    checked_date date,
    drafter_id bigint REFERENCES employees(id) ON DELETE SET NULL,
    checker_id bigint REFERENCES employees(id) ON DELETE SET NULL,

    revision varchar(20),
    sheet_no integer,
    total_sheets integer,
    drawing_scale project_drawing_scale,

    drafted_in_field boolean NOT NULL DEFAULT false,
    recording_requested boolean,

    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_project_survey_details_certifying_surveyor_id ON project_survey_details (certifying_surveyor_id);
CREATE INDEX idx_project_survey_details_drafter_id ON project_survey_details (drafter_id);
CREATE INDEX idx_project_survey_details_checker_id ON project_survey_details (checker_id);

-- +goose Down
DROP TABLE project_survey_details;
DROP TYPE project_drawing_scale;
DROP TYPE project_vertical_datum;
DROP TYPE project_horizontal_datum;
