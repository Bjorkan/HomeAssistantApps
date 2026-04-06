ARG BUILD_FROM=ghcr.io/l5yth/potato-mesh-ingestor-linux-arm64:v0.5.12
FROM ${BUILD_FROM}

# Home Assistant mounts add-on options at /data/options.json and the file can be
# root-owned. Run wrapper as root so config can always be read.
USER root

COPY --chmod=0755 run.sh /run.sh

ENTRYPOINT ["/run.sh"]
