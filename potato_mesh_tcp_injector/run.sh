#!/bin/sh
set -eu

CONFIG_PATH="/data/options.json"

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
if isinstance(value, bool):
    print("1" if value else "0")
else:
    print(value)
PY
}

POTATO_MESH_URL="$(read_option potato_mesh_url http://127.0.0.1:41447)"
API_TOKEN_VALUE="$(read_option api_token '')"
NODE_IP="$(read_option node_ip 192.168.1.100)"
NODE_TCP_PORT="$(read_option node_tcp_port 4403)"
TIMEZONE_VALUE="$(read_option timezone Europe/Stockholm)"
DEBUG_BOOL="$(read_option debug 0)"
ALLOWED_CHANNELS_VALUE="$(read_option allowed_channels '')"
HIDDEN_CHANNELS_VALUE="$(read_option hidden_channels '')"

if [ -z "$API_TOKEN_VALUE" ] || [ "$API_TOKEN_VALUE" = "change-me" ]; then
    echo "ERROR: api_token must be set to a real Potato Mesh API token."
    exit 1
fi

export TZ="$TIMEZONE_VALUE"

# Keep compatibility with multiple ingestor env names across upstream revisions.
export POTATOMESH_INSTANCE="$POTATO_MESH_URL"
export INSTANCE_DOMAIN="$POTATO_MESH_URL"
export API_TOKEN="$API_TOKEN_VALUE"

# ENBART TCP: always build CONNECTION from node_ip:node_tcp_port.
export CONNECTION="${NODE_IP}:${NODE_TCP_PORT}"

if [ "$DEBUG_BOOL" = "1" ]; then
    export DEBUG="1"
else
    export DEBUG="0"
fi

if [ -n "$ALLOWED_CHANNELS_VALUE" ]; then
    export ALLOWED_CHANNELS="$ALLOWED_CHANNELS_VALUE"
fi

if [ -n "$HIDDEN_CHANNELS_VALUE" ]; then
    export HIDDEN_CHANNELS="$HIDDEN_CHANNELS_VALUE"
fi

echo "------------------------------------------------------------"
echo "Starting Potato Mesh TCP Injector"
echo "Potato Mesh URL: ${POTATOMESH_INSTANCE}"
echo "TCP connection target: ${CONNECTION}"
echo "Timezone: ${TZ}"
echo "Debug: ${DEBUG}"
echo "------------------------------------------------------------"

if command -v docker-entrypoint.sh >/dev/null 2>&1; then
    exec docker-entrypoint.sh "$@"
fi

if [ -x /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh "$@"
fi

# Fallback if upstream image has no explicit entrypoint script in PATH.
exec python -m data.mesh
