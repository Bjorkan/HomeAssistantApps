#!/bin/sh
set -eu

# -----------------------------------------------------------------------------
# MeshMonitor HA app startup wrapper
#
# This script keeps the Home Assistant layer intentionally simple:
# - Node IP, TCP port and timezone are read from add-on options
# - Proxy/cookie behavior can be configured for HTTPS reverse proxies
#   or direct HTTP access
# - Virtual Node Server is always enabled on port 4404
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
if isinstance(value, bool):
    print("true" if value else "false")
else:
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
TRUST_PROXY_VALUE="$(read_option trust_proxy true)"
COOKIE_SECURE_VALUE="$(read_option cookie_secure true)"
ALLOWED_ORIGINS_VALUE="$(read_option allowed_origins '*')"

# Export environment variables expected by MeshMonitor.
export MESHTASTIC_NODE_IP="$NODE_IP"
export MESHTASTIC_TCP_PORT="$NODE_TCP_PORT"
export TZ="$TIMEZONE_VALUE"
export TRUST_PROXY="$TRUST_PROXY_VALUE"

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

# Allow direct HTTP access for development when cookie_secure is disabled.
export COOKIE_SECURE="$COOKIE_SECURE_VALUE"

# Persisted session secret for stable cookie encryption.
export SESSION_SECRET="$(cat "$SESSION_SECRET_FILE")"

# Allow user-defined origins (for example https://meshmonitor.example.com).
export ALLOWED_ORIGINS="$ALLOWED_ORIGINS_VALUE"

# Always enable MeshMonitor's Virtual Node Server.
# This allows Meshtastic mobile apps to connect through MeshMonitor
# using the default virtual node port from upstream documentation.
export ENABLE_VIRTUAL_NODE="true"
export VIRTUAL_NODE_PORT="4404"

echo "------------------------------------------------------------"
echo "Starting MeshMonitor HA app"
echo "Node IP: ${MESHTASTIC_NODE_IP}"
echo "Node TCP port: ${MESHTASTIC_TCP_PORT}"
echo "Timezone: ${TZ}"
echo "Internal web port: ${PORT}"
echo "Trust proxy: ${TRUST_PROXY}"
echo "Cookie secure: ${COOKIE_SECURE}"
echo "Allowed origins: ${ALLOWED_ORIGINS}"
echo "Virtual node enabled: ${ENABLE_VIRTUAL_NODE}"
echo "Virtual node port: ${VIRTUAL_NODE_PORT}"
echo "------------------------------------------------------------"

# Hand off to the original MeshMonitor container entrypoint.
# We preserve the original CMD arguments from the upstream image.
exec /usr/local/bin/docker-entrypoint.sh "$@"
