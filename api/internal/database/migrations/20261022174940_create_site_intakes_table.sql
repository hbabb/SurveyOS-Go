-- +goose Up
CREATE TABLE site_intakes (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    contact_id bigint NOT NULL REFERENCES contacts(id) ON DELETE RESTRICT,

    address_line_1 varchar(255),
    address_line_2 varchar(255),
    city varchar(120) NOT NULL,
    county varchar(120) NOT NULL,
    state varchar(2) NOT NULL,
    zip varchar(10),
    township varchar(120),
    pin varchar(60),

    notes text,
    CHECK ( address_line_1 IS NOT NULL OR pin IS NOT NULL ),

    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE INDEX idx_site_intakes_contact_id ON site_intakes (contact_id);
CREATE INDEX idx_site_intakes_city ON site_intakes (city);
CREATE INDEX idx_site_intakes_county ON site_intakes (county);
-- CREATE INDEX idx_site_intakes_state ON site_intakes (state);
CREATE INDEX idx_site_intakes_township ON site_intakes (township);
CREATE INDEX idx_site_intakes_pin ON site_intakes (pin);

-- +goose Down
DROP TABLE site_intakes;
