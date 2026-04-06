ARG BUILD_FROM=busybox:1.36.1
FROM $BUILD_FROM

COPY --chmod=755 run.sh /run.sh

ENTRYPOINT ["/run.sh"]
