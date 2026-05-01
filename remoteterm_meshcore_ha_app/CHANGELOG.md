# Changelog

## 0.0.6

- Switched RemoteTerm source back to the official `jkingsman/Remote-Terminal-for-MeshCore` release
- Pinned the bundled RemoteTerm source to `3.13.0`
- Removed TCP proxy options and the `5001/tcp` port because the pinned upstream release does not include that feature

## 0.0.5

- Switched RemoteTerm source to the `Bjorkan/Remote-Terminal-for-MeshCore` `TraceFix` branch
- Updated app metadata to point at the `TraceFix` branch

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
