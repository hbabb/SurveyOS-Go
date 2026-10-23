pod_file := "deploy/surveyos-dev.kube.yaml"
goose := "doppler run -- go -C api tool goose"

# Create a new timestamped goose migration
migrate-new name:
    {{goose}} create "{{name}}" sql

# Apply all pending migrations
migrate-up:
    {{goose}} up

# Roll back the most recent migration
migrate-down:
    {{goose}} down

# Show which migrations are applied
migrate-status:
    {{goose}} status

# Start the dev pod
pod-up:
    podman kube play {{pod_file}}

# Stop the dev pod (keeps the database)
pod-down:
    podman kube play --down {{pod_file}}

# Recreate the dev pod after changing its file
pod-replace:
    podman kube play --replace {{pod_file}}

# Show the dev pod's containers by name
pod-status:
    podman ps --pod --filter pod=surveyos-dev --format "{{{{.Names}}  {{{{.Image}}  {{{{.Status}}"
