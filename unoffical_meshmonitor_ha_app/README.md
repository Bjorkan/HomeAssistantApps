# MeshMonitor HA app (Unoffical)

A minimal Home Assistant app wrapper around MeshMonitor.

Supports reverse-proxy aware session cookie settings (`TRUST_PROXY`, `COOKIE_SECURE`, and `ALLOWED_ORIGINS`) through add-on options.
Virtual Node Server is always enabled on port `4404` according to MeshMonitor's upstream guidance.

## License

The Home Assistant wrapper and repository files in this project are licensed under the MIT License.

This project packages and references MeshMonitor as an upstream dependency.
MeshMonitor is a separate project and remains licensed under its own license (BSD-3-Clause).
