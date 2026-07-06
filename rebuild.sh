#!/usr/bin/env bash
# Rebuild and (re)run the Equipment Rental app in a Podman container.
# Usage:  chmod +x rebuild.sh  &&  ./rebuild.sh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="equipment-rental"
IMAGE_NAME="equipment-rental:latest"
HOST_PORT=5000

echo ">> Removing old container (if any)..."
podman rm -f "${CONTAINER_NAME}" 2>/dev/null || true

echo ">> Building image: ${IMAGE_NAME}"
podman build -t "${IMAGE_NAME}" "${PROJECT_DIR}"

echo ">> Starting container: ${CONTAINER_NAME}"
# Mount bookings.json from the host so bookings persist across rebuilds.
podman run -d \
    --name "${CONTAINER_NAME}" \
    -p "${HOST_PORT}:5000" \
    -v "${PROJECT_DIR}/bookings.json:/app/bookings.json:z" \
    "${IMAGE_NAME}"

echo ">> Equipment Rental running at: http://localhost:${HOST_PORT}"

