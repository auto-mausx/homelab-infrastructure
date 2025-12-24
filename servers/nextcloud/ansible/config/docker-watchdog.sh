#!/bin/sh
set -eu

INTERVAL="${INTERVAL:-60}"
TARGET_CONTAINER="${TARGET_CONTAINER:-tailscale}"  # must match container_name
UP_ARGS="${UP_ARGS:-}"  # extra args for 'tailscale up' if you want them (e.g. "--reset")

echo "[$(date -Iseconds)] docker-watchdog starting. Interval=${INTERVAL}s, target=${TARGET_CONTAINER}"

while true; do
  # Run tailscale status inside the container
  STATUS_OUTPUT="$(docker exec "${TARGET_CONTAINER}" tailscale status --json 2>&1 || true)"
  STATUS_EXIT=$?

  if [ $STATUS_EXIT -ne 0 ]; then
    # tailscale status itself failed (container restarting, tailscaled not up yet, etc.)
    echo "[$(date -Iseconds)] 'tailscale status --json' failed (exit ${STATUS_EXIT}); output:"
    echo "$STATUS_OUTPUT"
    echo "[$(date -Iseconds)] Running 'tailscale down' + 'tailscale up ${UP_ARGS}' inside ${TARGET_CONTAINER}..."
    docker exec "${TARGET_CONTAINER}" tailscale down || true
    docker exec "${TARGET_CONTAINER}" sh -lc "tailscale up ${UP_ARGS}" || true
    sleep "${INTERVAL}"
    continue
  fi

  # Check BackendState in a whitespace-tolerant way:
  # matches: "BackendState":"Running" OR "BackendState": "Running" etc.
  if printf '%s\n' "$STATUS_OUTPUT" | grep -q '"BackendState"[[:space:]]*:[[:space:]]*"Running"'; then
    # Healthy – do nothing
    # echo "[$(date -Iseconds)] BackendState=Running; leaving container alone."
    :
  else
    echo "[$(date -Iseconds)] tailscale appears unhealthy in container ${TARGET_CONTAINER}"
    echo "[$(date -Iseconds)] tailscale status output:"
    echo "$STATUS_OUTPUT"

    echo "[$(date -Iseconds)] Running 'tailscale down' inside ${TARGET_CONTAINER}..."
    docker exec "${TARGET_CONTAINER}" tailscale down || true

    echo "[$(date -Iseconds)] Running 'tailscale up ${UP_ARGS}' inside ${TARGET_CONTAINER}..."
    docker exec "${TARGET_CONTAINER}" sh -lc "tailscale up ${UP_ARGS}" || true
  fi

  sleep "${INTERVAL}"
done