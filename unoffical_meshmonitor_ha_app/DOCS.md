# MeshMonitor HA app (Unoffical)

A minimal Unoffical Home Assistant app wrapper for [MeshMonitor](https://github.com/Yeraze/meshmonitor).

## What this app does

This app reuses the upstream MeshMonitor container and adds a very small Home Assistant wrapper so you can configure:

- Optional Meshtastic node IP address
- Optional Meshtastic node TCP port
- Optional MeshCore connection settings
- The timezone
- Proxy/cookie settings for secure session cookies
- Allowed web origins

The app can enable MeshMonitor's Virtual Node Server on port `4404` based on upstream guidance:
https://meshmonitor.org/configuration/virtual-node.html

## What is intentionally kept simple

- Meshtastic TCP is optional and still configured via `node_ip` + `node_tcp_port`
- MeshCore is optional and disabled by default
- Virtual Node Server can be enabled or disabled on container port `4404`

## Setting the web port

The web interface port is changed in the Home Assistant app **Network** settings.

By default, this app maps:

- Container port `3001/tcp`
- Host port `8080`
- Container port `4404/tcp`
- Host port `4404`

You can change the host port in Home Assistant to any free port you want.

## Configuration

### `node_ip`
IP address of the Meshtastic node.
Leave empty for MeshCore-only installs.

Example:
`192.168.1.100`

### `node_tcp_port`
TCP port used by the Meshtastic node.
Leave empty for MeshCore-only installs.

Default:
`4403`

### `timezone`
Timezone passed into the MeshMonitor container.

Example:
`Europe/Stockholm`

### `trust_proxy`
Set to `true` when running behind an HTTPS reverse proxy (recommended).
This makes MeshMonitor trust `X-Forwarded-Proto` so secure cookies can be set.

Default:
`true`

### `cookie_secure`
Set to `true` for HTTPS deployments.
Set to `false` only for direct HTTP development/testing.

Default:
`true`

### `allowed_origins`
Allowed CORS origins for the web UI.
Use a specific HTTPS origin in production when possible.

Examples:
`https://meshmonitor.example.com`
`*`

### `virtual_node_enabled`
Enable MeshMonitor's Virtual Node Server for Meshtastic mobile app TCP access.

Default:
`true`

### `meshcore_enabled`
Enable MeshCore auto-connect in upstream MeshMonitor.

Default:
`false`

### `meshcore_tcp_host`
Host or IP address of the MeshCore node.

Example:
`192.168.1.150`

### `meshcore_tcp_port`
TCP port for the MeshCore node.

Default:
`5000`

## Install

1. Add this repository to Home Assistant.
2. Install **MeshMonitor HA (Unoffical) app**.
3. Set `timezone`.
4. If you want Meshtastic TCP, set `node_ip` and optionally `node_tcp_port`.
5. If you want MeshCore, enable `meshcore_enabled` and fill in the TCP settings.
6. Choose whether `virtual_node_enabled` should be on.
7. Adjust the **Network** port if needed.
8. Start the app.
9. Open the web UI from the add-on page.

## MeshCore setup examples

### Example A: MeshCore over TCP/IP

- `meshcore_enabled: true`
- `meshcore_tcp_host: 192.168.1.150`
- `meshcore_tcp_port: 5000`

## Proxy and cookie setup scenarios

### Scenario A: Behind HTTPS reverse proxy (recommended)

- `trust_proxy: true`
- `cookie_secure: true`
- `allowed_origins: https://meshmonitor.example.com` (or your domain)

### Scenario B: Direct HTTP access (development/testing only)

- `trust_proxy: false`
- `cookie_secure: false`
- `allowed_origins: *`

⚠️ This is less secure and should not be used for production internet-facing deployments.

### Scenario C: Direct HTTPS access

- `trust_proxy: false` (unless another proxy is involved)
- `cookie_secure: true`
- `allowed_origins` set to your HTTPS origin
