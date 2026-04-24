# RemoteTerm for MeshCore HA app

A minimal Unoffical Home Assistant app wrapper for [RemoteTerm for MeshCore](https://github.com/jkingsman/Remote-Terminal-for-MeshCore).

## What this app does

This app reuses the upstream RemoteTerm container and adds a small Home Assistant wrapper so you can configure:

- The MeshCore TCP host
- The MeshCore TCP port
- The timezone
- Log level
- Whether the bot system should be disabled
- Whether local private key export should be enabled
- Optional HTTP Basic auth

The add-on exposes the RemoteTerm web UI on container port `8000`.

## What is intentionally kept simple

- This wrapper currently supports MeshCore over TCP only
- Serial and BLE transports are not exposed through Home Assistant options
- The upstream app's database is stored in `/data/meshcore.db`

## Setting the web port

The web interface port is changed in the Home Assistant app **Network** settings.

By default, this app maps:

- Container port `8000/tcp`
- Host port `8000`

## Configuration

### `meshcore_tcp_host`
Host or IP address of the MeshCore node.

Example:
`192.168.1.100`

### `meshcore_tcp_port`
TCP port for the MeshCore node.

Default:
`5000`

### `timezone`
Timezone passed into the RemoteTerm container.

Example:
`Europe/Stockholm`

### `log_level`
Upstream log verbosity.

Allowed values:
`DEBUG`
`INFO`
`WARNING`
`ERROR`

Default:
`INFO`

### `disable_bots`
Disable the upstream bot system entirely.

Default:
`true`

### `enable_local_private_key_export`
Enable the upstream private key export endpoint.
Only enable this on a trusted network.

Default:
`false`

### `basic_auth_username`
Optional app-wide HTTP Basic auth username.
Must be set together with `basic_auth_password`.

### `basic_auth_password`
Optional app-wide HTTP Basic auth password.
Must be set together with `basic_auth_username`.

## Install

1. Add this repository to Home Assistant.
2. Install **RemoteTerm for MeshCore HA app**.
3. Set `meshcore_tcp_host` and `meshcore_tcp_port`.
4. Review the security-related options before exposing the UI to other devices.
5. Adjust the **Network** port if needed.
6. Start the app.
7. Open the web UI from the add-on page.

## Security notes

- This project is intended for trusted environments only
- Keep `disable_bots: true` unless you specifically need bot execution
- Use HTTP Basic auth only together with HTTPS
- Keep `enable_local_private_key_export: false` unless you actively need it
