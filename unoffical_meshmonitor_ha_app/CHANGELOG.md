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
