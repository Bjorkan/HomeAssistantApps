ARG BUILD_FROM=ghcr.io/l5yth/potato-mesh-ingestor-linux-arm64:v0.5.12
FROM ${BUILD_FROM}

COPY --chmod=0755 run.sh /run.sh

ENTRYPOINT ["/run.sh"]
