# MeshCore Live Map HA app (Unoffical)

A minimal Home Assistant app wrapper around [meshcore-mqtt-live-map](https://github.com/yellowcooln/meshcore-mqtt-live-map).

## Notes

- The app connects to your MQTT broker using options configured in Home Assistant.
- The internal web port is fixed to `8080`. Change the host-side port from Home Assistant Network settings.

## License

The Home Assistant wrapper and repository files in this project are licensed under the MIT License.

This project packages and references meshcore-mqtt-live-map as an upstream dependency.
meshcore-mqtt-live-map remains licensed under its own license.
