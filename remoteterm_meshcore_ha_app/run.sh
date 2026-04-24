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
    print("true" if value else "false")
else:
    print(value)
PY
}

MESHCORE_TCP_HOST_VALUE="$(read_option meshcore_tcp_host 192.168.1.100)"
MESHCORE_TCP_PORT_VALUE="$(read_option meshcore_tcp_port 5000)"
TIMEZONE_VALUE="$(read_option timezone Europe/Stockholm)"
LOG_LEVEL_VALUE="$(read_option log_level INFO)"
DISABLE_BOTS_VALUE="$(read_option disable_bots true)"
ENABLE_LOCAL_PRIVATE_KEY_EXPORT_VALUE="$(read_option enable_local_private_key_export false)"
BASIC_AUTH_USERNAME_VALUE="$(read_option basic_auth_username '')"
BASIC_AUTH_PASSWORD_VALUE="$(read_option basic_auth_password '')"

if [ -z "$MESHCORE_TCP_HOST_VALUE" ]; then
    echo "ERROR: meshcore_tcp_host must be set."
    exit 1
fi

export TZ="$TIMEZONE_VALUE"
export MESHCORE_TCP_HOST="$MESHCORE_TCP_HOST_VALUE"
export MESHCORE_TCP_PORT="$MESHCORE_TCP_PORT_VALUE"
export MESHCORE_LOG_LEVEL="$LOG_LEVEL_VALUE"
export MESHCORE_DATABASE_PATH="/data/meshcore.db"
export MESHCORE_DISABLE_BOTS="$DISABLE_BOTS_VALUE"
export MESHCORE_ENABLE_LOCAL_PRIVATE_KEY_EXPORT="$ENABLE_LOCAL_PRIVATE_KEY_EXPORT_VALUE"

if [ -n "$BASIC_AUTH_USERNAME_VALUE" ] || [ -n "$BASIC_AUTH_PASSWORD_VALUE" ]; then
    if [ -z "$BASIC_AUTH_USERNAME_VALUE" ] || [ -z "$BASIC_AUTH_PASSWORD_VALUE" ]; then
        echo "ERROR: basic_auth_username and basic_auth_password must both be set together."
        exit 1
    fi
    export MESHCORE_BASIC_AUTH_USERNAME="$BASIC_AUTH_USERNAME_VALUE"
    export MESHCORE_BASIC_AUTH_PASSWORD="$BASIC_AUTH_PASSWORD_VALUE"
else
    unset MESHCORE_BASIC_AUTH_USERNAME
    unset MESHCORE_BASIC_AUTH_PASSWORD
fi

echo "------------------------------------------------------------"
echo "Starting RemoteTerm for MeshCore HA app"
echo "MeshCore TCP host: ${MESHCORE_TCP_HOST}"
echo "MeshCore TCP port: ${MESHCORE_TCP_PORT}"
echo "Timezone: ${TZ}"
echo "Log level: ${MESHCORE_LOG_LEVEL}"
echo "Bots disabled: ${MESHCORE_DISABLE_BOTS}"
echo "Private key export enabled: ${MESHCORE_ENABLE_LOCAL_PRIVATE_KEY_EXPORT}"
if [ -n "${BASIC_AUTH_USERNAME_VALUE}" ]; then
    echo "Basic auth: enabled"
else
    echo "Basic auth: disabled"
fi
echo "Database path: ${MESHCORE_DATABASE_PATH}"
echo "------------------------------------------------------------"

exec "$@"
