# Changelog

## 0.0.1

- Initial barebones Home Assistant app wrapper for MeshMonitor
- Added Home Assistant options for node IP, node TCP port, and timezone
- Pinned upstream MeshMonitor image to `3.9.5`
- Kept `ALLOWED_ORIGINS=*`
- Disabled virtual node support to keep scope limited to TCP/IP node access

## 0.0.2

- Updated upstream Meshmonitor app to "3.11.1"

## 0.0.3

- Added add-on options for `trust_proxy`, `cookie_secure`, and `allowed_origins`
- Updated startup wrapper to export proxy/cookie environment settings for MeshMonitor
- Documented HTTPS reverse proxy, direct HTTP, and direct HTTPS deployment scenarios
- Fixed boolean option rendering so `trust_proxy`/`cookie_secure` are exported as lowercase `true`/`false`

## 0.0.4
- Update upstream Meshmonitor app to "3.12.0"

## 0.0.5
- Enabled MeshMonitor Virtual Node Server by default (`ENABLE_VIRTUAL_NODE=true`)
- Added fixed virtual node port export (`VIRTUAL_NODE_PORT=4404`)
- Exposed add-on network port `4404/tcp` for Meshtastic mobile app TCP connections

## 0.0.6
- Added Home Assistant options for optional MeshCore connectivity
- Forwarded `MESHCORE_*` environment variables to upstream MeshMonitor for auto-connect
- Made `node_ip` and `node_tcp_port` optional for MeshCore-only installs
- Updated the startup wrapper to skip `MESHTASTIC_*` exports when no Meshtastic TCP node is configured
- Made Virtual Node Server configurable through a new `virtual_node_enabled` add-on option
- Updated the startup wrapper to export `ENABLE_VIRTUAL_NODE` only from add-on settings
- Documented MeshCore TCP and serial configuration examples
