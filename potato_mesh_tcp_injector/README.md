# Potato Mesh TCP Injector (Home Assistant add-on)

Detta add-on kör **endast Potato Mesh injectorn** och ansluter till en Meshtastic-nod via **TCP**.

## Vad add-onet gör

- Startar Potato Mesh ingestor i containern
- Läser Home Assistant-inställningar från `options.json`
- Skapar alltid `CONNECTION` som `node_ip:node_tcp_port`
- Skickar data till din Potato Mesh-instans via API

Ingen seriell USB/BLE-konfiguration stöds i detta add-on.

## Konfiguration

- `potato_mesh_url`: URL till Potato Mesh-webbappen (t.ex. `http://192.168.1.50:41447`)
- `api_token`: API-token från Potato Mesh (`API_TOKEN`)
- `node_ip`: IP för Meshtastic-enheten
- `node_tcp_port`: TCP-port på Meshtastic-enheten (vanligtvis `4403`)
- `timezone`: Tidszon för loggar
- `debug`: Slår på verbose-loggning
- `allowed_channels`: Frivillig kommaseparerad allowlist av kanaler
- `hidden_channels`: Frivillig kommaseparerad blocklist av kanaler

## Installera

1. Lägg till detta add-on repository i Home Assistant.
2. Installera **Potato Mesh TCP Injector**.
3. Ange `potato_mesh_url`, `api_token`, `node_ip` och `node_tcp_port`.
4. Starta add-onet.
5. Kontrollera loggen för bekräftad TCP-anslutning.
