#!/bin/sh
set -eu

# -----------------------------------------------------------------------------
# MeshMonitor HA app startup wrapper
#
# This script keeps the Home Assistant layer intentionally simple:
# - Node IP, TCP port and timezone are read from add-on options
# - ALLOWED_ORIGINS is always set to "*" as requested
# - Virtual Node support is disabled to keep this app focused on
#   a single TCP/IP connection to the target node
# - The internal MeshMonitor web port remains 3001
#
# Important:
# The user-facing web port should be changed in the Home Assistant
# add-on Network settings, not here. Home Assistant maps the host
# port to the internal container port 3001.
# -----------------------------------------------------------------------------

CONFIG_PATH="/data/options.json"
SESSION_SECRET_FILE="/data/meshmonitor_ha_session_secret"

# Read a single value from Home Assistant's options.json.
# The third argument is the fallback default if the file or key is missing.
read_option() {
    python3 - "$CONFIG_PATH" "$1" "$2" <<'PY'
import json
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
key = sys.argv[2]
default = sys.argv[3]

if not config_path.exists():
    print(default)
    raise SystemExit(0)

with config_path.open("r", encoding="utf-8") as handle:
    data = json.load(handle)

value = data.get(key, default)

# Print the value exactly once so shell command substitution can use it.
print(value)
PY
}

# Generate a stable session secret on first boot.
# Keeping it in /data ensures logins remain stable across restarts.
if [ ! -s "$SESSION_SECRET_FILE" ]; then
    python3 - <<'PY' > "$SESSION_SECRET_FILE"
import secrets
print(secrets.token_urlsafe(48))
PY
    chmod 600 "$SESSION_SECRET_FILE"
fi

# Read Home Assistant options.
NODE_IP="$(read_option node_ip 192.168.1.100)"
NODE_TCP_PORT="$(read_option node_tcp_port 4403)"
TIMEZONE_VALUE="$(read_option timezone Europe/Stockholm)"

# Export environment variables expected by MeshMonitor.
export MESHTASTIC_NODE_IP="$NODE_IP"
export MESHTASTIC_TCP_PORT="$NODE_TCP_PORT"
export TZ="$TIMEZONE_VALUE"

# Keep the internal application port fixed.
# Home Assistant should handle the external/host-side port mapping.
export PORT="3001"

# Data storage for MeshMonitor
export DATA_DIR="/data"
export DATABASE_PATH="/data/meshmonitor.db"
export BACKUP_DIR="/data/backups"
export SYSTEM_BACKUP_DIR="/data/system-backups"
export APPRISE_CONFIG_DIR="/data/apprise-config"
export ACCESS_LOG_PATH="/data/logs/access.log"

# Keep direct HTTP access simple for local Home Assistant use.
export COOKIE_SECURE="false"

# Persisted session secret for stable cookie encryption.
export SESSION_SECRET="$(cat "$SESSION_SECRET_FILE")"

# Requested behavior: keep allowed origins as wildcard.
export ALLOWED_ORIGINS="*"

# Requested behavior: TCP/IP connection to the node only.
# Disable MeshMonitor's virtual node server to keep scope small.
export ENABLE_VIRTUAL_NODE="false"

echo "------------------------------------------------------------"
echo "Starting MeshMonitor HA app"
echo "Node IP: ${MESHTASTIC_NODE_IP}"
echo "Node TCP port: ${MESHTASTIC_TCP_PORT}"
echo "Timezone: ${TZ}"
echo "Internal web port: ${PORT}"
echo "Allowed origins: ${ALLOWED_ORIGINS}"
echo "Virtual node enabled: ${ENABLE_VIRTUAL_NODE}"
echo "------------------------------------------------------------"

# Hand off to the original MeshMonitor container entrypoint.
# We preserve the original CMD arguments from the upstream image.
exec /usr/local/bin/docker-entrypoint.sh "$@"
