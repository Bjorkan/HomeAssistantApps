ARG BUILD_FROM
FROM $BUILD_FROM

# Copy the Home Assistant wrapper script.
# This script reads add-on options from /data/options.json
# and forwards them to the upstream RemoteTerm container
# as environment variables.
COPY run.sh /run.sh

RUN chmod +x /run.sh

# Replace the upstream entrypoint with our wrapper.
ENTRYPOINT ["/run.sh"]

# Preserve the upstream startup command.
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
