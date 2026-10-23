-- +goose Up
ALTER TABLE proposals
ADD COLUMN change_order_project_id bigint REFERENCES projects(id) ON DELETE RESTRICT;

CREATE INDEX idx_proposals_change_order_project_id ON proposals(change_order_project_id);

-- +goose Down
DROP INDEX idx_proposals_change_order_project_id;
ALTER TABLE proposals
DROP COLUMN change_order_project_id;
