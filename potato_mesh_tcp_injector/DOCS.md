# Potato Mesh TCP Injector

Home Assistant add-on för Potato Mesh-ingestorn med fokus på **ENBART TCP**.

## Viktigt

- Add-onet bygger alltid `CONNECTION=<node_ip>:<node_tcp_port>`.
- Seriell och BLE-anslutning är avsiktligt exkluderade.

## Exempelkonfiguration

```yaml
potato_mesh_url: http://192.168.1.50:41447
api_token: my-secret-token
node_ip: 192.168.1.100
node_tcp_port: 4403
timezone: Europe/Stockholm
debug: false
allowed_channels: "Chat,Ops"
hidden_channels: "Private"
```
