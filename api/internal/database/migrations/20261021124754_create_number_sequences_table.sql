-- +goose Up
CREATE TABLE number_sequences (
    sequence_type varchar(20) NOT NULL,
    year integer NOT NULL,
    next_number integer NOT NULL DEFAULT 1,
    PRIMARY KEY (sequence_type, year)
);

-- +goose Down
DROP TABLE number_sequences;
