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

if not config_path.exists():
    print(default)
    raise SystemExit(0)

with config_path.open("r", encoding="utf-8") as handle:
    data = json.load(handle)

value = data.get(key, default)
if isinstance(value, bool):
    print("true" if value else "false")
else:
    print(value)
PY
}

export TZ="$(read_option timezone UTC)"
export SITE_TITLE="$(read_option site_title 'Mesh Live Map')"
export SITE_DESCRIPTION="$(read_option site_description 'Live view of mesh nodes, message routes, and advert paths.')"

export MQTT_HOST="$(read_option mqtt_host broker.example.local)"
export MQTT_PORT="$(read_option mqtt_port 1883)"
export MQTT_USERNAME="$(read_option mqtt_username '')"
export MQTT_PASSWORD="$(read_option mqtt_password '')"
export MQTT_TRANSPORT="$(read_option mqtt_transport tcp)"
export MQTT_WS_PATH="$(read_option mqtt_ws_path /mqtt)"
export MQTT_TLS="$(read_option mqtt_tls false)"
export MQTT_TOPIC="$(read_option mqtt_topic 'meshcore/#')"

export MAP_START_LAT="$(read_option map_start_lat 42.3601)"
export MAP_START_LON="$(read_option map_start_lon -71.1500)"
export MAP_START_ZOOM="$(read_option map_start_zoom 10)"

export PROD_MODE="$(read_option prod_mode false)"
export PROD_TOKEN="$(read_option prod_token '')"

export WEB_PORT="8080"
export STATE_DIR="/data"
export BACKUP_DIR="/data/backups"
export GIT_CHECK_ENABLED="false"

echo "Starting MeshCore Live Map HA app"
echo "MQTT host: ${MQTT_HOST}"
echo "MQTT port: ${MQTT_PORT}"
echo "MQTT topic: ${MQTT_TOPIC}"
echo "Transport: ${MQTT_TRANSPORT}"
echo "TLS: ${MQTT_TLS}"
echo "Port: ${WEB_PORT}"

cd /opt/meshcore-mqtt-live-map/backend
exec uvicorn app:app --host 0.0.0.0 --port "${WEB_PORT}"
