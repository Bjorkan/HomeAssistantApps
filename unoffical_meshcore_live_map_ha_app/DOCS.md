# MeshCore Live Map HA app

## Configuration

- `timezone`: Container timezone value (`TZ`)
- `site_title`: UI title shown in the browser
- `site_description`: UI description / metadata
- `mqtt_host`: MQTT broker hostname/IP
- `mqtt_port`: MQTT broker port
- `mqtt_username`: Optional MQTT username
- `mqtt_password`: Optional MQTT password
- `mqtt_transport`: `tcp` or `websockets`
- `mqtt_ws_path`: WebSocket path (used when `mqtt_transport=websockets`)
- `mqtt_tls`: Enable TLS for MQTT connection
- `mqtt_topic`: MQTT topic pattern (example: `meshcore/#`)
- `map_start_lat`: Default map latitude
- `map_start_lon`: Default map longitude
- `map_start_zoom`: Default map zoom
- `prod_mode`: Require token for protected API/WS routes
- `prod_token`: Token used when `prod_mode=true`
