# Changelog

## 0.0.4

- Switched RemoteTerm source to the upstream `Bjorkan/ha-remoteterm-app` `tcp-proxy` branch
- Updated app metadata to point at the Bjorkan upstream repository

## 0.0.3

- Pointed the RemoteTerm add-on at the upstream `tcp-proxy` branch
- Built RemoteTerm from the upstream `tcp-proxy` branch source
- Added TCP proxy options and exposed the proxy port on `5001/tcp`

## 0.0.2

- Updated upstream RemoteTerm for MeshCore container to `3.12.3`

## 0.0.1

- Initial Home Assistant app wrapper for RemoteTerm for MeshCore
- Added TCP-based MeshCore configuration options
- Added optional Basic auth, log level, bot disable, and private key export settings
- Exposed the upstream web UI on port `8000`
