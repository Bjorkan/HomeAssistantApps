# MeshMonitor HA app (Unoffical)

A minimal Home Assistant app wrapper around MeshMonitor.

Supports reverse-proxy aware session cookie settings (`TRUST_PROXY`, `COOKIE_SECURE`, and `ALLOWED_ORIGINS`) through add-on options.
Virtual Node Server can be enabled or disabled through add-on options, using port `4404` when enabled.
Optional MeshCore connectivity can also be configured through add-on options, and Meshtastic TCP can now be left unset for MeshCore-only installs.

## License

The Home Assistant wrapper and repository files in this project are licensed under the MIT License.

This project packages and references MeshMonitor as an upstream dependency.
MeshMonitor is a separate project and remains licensed under its own license (BSD-3-Clause).
