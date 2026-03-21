ARG BUILD_FROM
FROM $BUILD_FROM

# Copy the Home Assistant wrapper script.
# This script reads add-on options from /data/options.json
# and forwards them to the upstream MeshMonitor container
# as environment variables.
COPY run.sh /run.sh

RUN chmod +x /run.sh

# Replace the upstream entrypoint with our wrapper.
# The wrapper will still hand off execution to the original
# MeshMonitor entrypoint after preparing the environment.
ENTRYPOINT ["/run.sh"]

# Explicitly preserve the upstream MeshMonitor startup command.
# MeshMonitor's docker-entrypoint.sh expects these arguments to exist.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
