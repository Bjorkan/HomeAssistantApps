# RemoteTerm for MeshCore HA app

A minimal Home Assistant app wrapper around RemoteTerm for MeshCore.

This wrapper builds the upstream `TraceFix` branch, connects RemoteTerm to a MeshCore radio over TCP, and maps Home Assistant options to the upstream application's `MESHCORE_*` environment variables. The optional MeshCore TCP proxy can expose RemoteTerm as a companion TCP endpoint for other MeshCore clients.
