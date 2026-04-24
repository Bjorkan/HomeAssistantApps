#!/bin/sh
set -eu

# -----------------------------------------------------------------------------
# MeshMonitor HA app startup wrapper
#
# This script keeps the Home Assistant layer intentionally simple:
# - Node IP, TCP port and timezone are read from add-on options
# - Optional MeshCore connection settings can be forwarded to upstream
# - Proxy/cookie behavior can be configured for HTTPS reverse proxies
#   or direct HTTP access
# - Virtual Node Server can be enabled on port 4404
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

try:
    if not config_path.exists():
        print(default)
        raise SystemExit(0)

    with config_path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
except (PermissionError, json.JSONDecodeError, OSError):
    print(default)
    raise SystemExit(0)

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
NODE_IP="$(read_option node_ip '')"
NODE_TCP_PORT="$(read_option node_tcp_port '')"
TIMEZONE_VALUE="$(read_option timezone Europe/Stockholm)"
TRUST_PROXY_VALUE="$(read_option trust_proxy true)"
COOKIE_SECURE_VALUE="$(read_option cookie_secure true)"
ALLOWED_ORIGINS_VALUE="$(read_option allowed_origins '*')"
VIRTUAL_NODE_ENABLED_VALUE="$(read_option virtual_node_enabled true)"
MESHCORE_ENABLED_VALUE="$(read_option meshcore_enabled false)"
MESHCORE_CONNECTION_TYPE_VALUE="$(read_option meshcore_connection_type tcp)"
MESHCORE_TCP_HOST_VALUE="$(read_option meshcore_tcp_host '')"
MESHCORE_TCP_PORT_VALUE="$(read_option meshcore_tcp_port 4403)"
MESHCORE_SERIAL_PORT_VALUE="$(read_option meshcore_serial_port '')"
MESHCORE_BAUD_RATE_VALUE="$(read_option meshcore_baud_rate 115200)"
MESHCORE_FIRMWARE_TYPE_VALUE="$(read_option meshcore_firmware_type companion)"

# Export environment variables expected by MeshMonitor.
# Meshtastic TCP is optional so MeshCore-only installs can leave these unset.
if [ -n "$NODE_IP" ]; then
    export MESHTASTIC_NODE_IP="$NODE_IP"
    if [ -n "$NODE_TCP_PORT" ]; then
        export MESHTASTIC_TCP_PORT="$NODE_TCP_PORT"
    else
        export MESHTASTIC_TCP_PORT="4403"
    fi
else
    unset MESHTASTIC_NODE_IP
    unset MESHTASTIC_TCP_PORT
fi
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

# Optional MeshCore support. Upstream will auto-connect on startup when
# MESHCORE_ENABLED=true and either TCP host or serial port is configured.
export MESHCORE_ENABLED="$MESHCORE_ENABLED_VALUE"

if [ "$MESHCORE_ENABLED" = "true" ]; then
    export MESHCORE_FIRMWARE_TYPE="$MESHCORE_FIRMWARE_TYPE_VALUE"

    if [ "$MESHCORE_CONNECTION_TYPE_VALUE" = "serial" ]; then
        export MESHCORE_SERIAL_PORT="$MESHCORE_SERIAL_PORT_VALUE"
        export MESHCORE_BAUD_RATE="$MESHCORE_BAUD_RATE_VALUE"
        unset MESHCORE_TCP_HOST
        unset MESHCORE_TCP_PORT
    else
        export MESHCORE_TCP_HOST="$MESHCORE_TCP_HOST_VALUE"
        export MESHCORE_TCP_PORT="$MESHCORE_TCP_PORT_VALUE"
        unset MESHCORE_SERIAL_PORT
        unset MESHCORE_BAUD_RATE
    fi
else
    unset MESHCORE_FIRMWARE_TYPE
    unset MESHCORE_TCP_HOST
    unset MESHCORE_TCP_PORT
    unset MESHCORE_SERIAL_PORT
    unset MESHCORE_BAUD_RATE
fi

# Optional Virtual Node Server support for Meshtastic mobile app TCP access.
export ENABLE_VIRTUAL_NODE="$VIRTUAL_NODE_ENABLED_VALUE"
if [ "$ENABLE_VIRTUAL_NODE" = "true" ]; then
    export VIRTUAL_NODE_PORT="4404"
else
    unset VIRTUAL_NODE_PORT
fi

echo "------------------------------------------------------------"
echo "Starting MeshMonitor HA app"
if [ -n "$NODE_IP" ]; then
    echo "Meshtastic node IP: ${MESHTASTIC_NODE_IP}"
    echo "Meshtastic node TCP port: ${MESHTASTIC_TCP_PORT}"
else
    echo "Meshtastic TCP node: disabled"
fi
echo "Timezone: ${TZ}"
echo "Internal web port: ${PORT}"
echo "Trust proxy: ${TRUST_PROXY}"
echo "Cookie secure: ${COOKIE_SECURE}"
echo "Allowed origins: ${ALLOWED_ORIGINS}"
echo "Virtual node enabled: ${ENABLE_VIRTUAL_NODE}"
if [ "$ENABLE_VIRTUAL_NODE" = "true" ]; then
    echo "Virtual node port: ${VIRTUAL_NODE_PORT}"
else
    echo "Virtual node port: disabled"
fi
echo "MeshCore enabled: ${MESHCORE_ENABLED}"
if [ "$MESHCORE_ENABLED" = "true" ]; then
    echo "MeshCore connection type: ${MESHCORE_CONNECTION_TYPE_VALUE}"
    echo "MeshCore firmware type: ${MESHCORE_FIRMWARE_TYPE_VALUE}"
    if [ "$MESHCORE_CONNECTION_TYPE_VALUE" = "serial" ]; then
        echo "MeshCore serial port: ${MESHCORE_SERIAL_PORT_VALUE}"
        echo "MeshCore baud rate: ${MESHCORE_BAUD_RATE_VALUE}"
    else
        echo "MeshCore host: ${MESHCORE_TCP_HOST_VALUE}"
        echo "MeshCore TCP port: ${MESHCORE_TCP_PORT_VALUE}"
    fi
fi
echo "------------------------------------------------------------"

# Hand off to the original MeshMonitor container entrypoint.
# We preserve the original CMD arguments from the upstream image.
exec /usr/local/bin/docker-entrypoint.sh "$@"
