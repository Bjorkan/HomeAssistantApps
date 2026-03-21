# MeshMonitor HA app (Unoffical)

A minimal Unoffical Home Assistant app wrapper for [MeshMonitor](https://github.com/Yeraze/meshmonitor).

## What this app does

This app reuses the upstream MeshMonitor container and adds a very small Home Assistant wrapper so you can configure:

- The Meshtastic node IP address
- The Meshtastic node TCP port
- The timezone

## What is intentionally kept simple

- Only TCP/IP connections to the target Meshtastic node are supported

## Setting the web port

The web interface port is changed in the Home Assistant app **Network** settings.

By default, this app maps:

- Container port `3001/tcp`
- Host port `8080`

You can change the host port in Home Assistant to any free port you want.

## Configuration

### `node_ip`
IP address of the Meshtastic node.

Example:
`192.168.1.100`

### `node_tcp_port`
TCP port used by the Meshtastic node.

Default:
`4403`

### `timezone`
Timezone passed into the MeshMonitor container.

Example:
`Europe/Stockholm`

## Install

1. Add this repository to Home Assistant.
2. Install **MeshMonitor HA (Unoffical) app**.
3. Set `node_ip`, `node_tcp_port`, and `timezone`.
4. Adjust the **Network** port if needed.
5. Start the app.
6. Open the web UI from the add-on page.
