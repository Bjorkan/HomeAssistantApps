FROM node:20-slim AS frontend-builder

ARG REMOTETERM_COMMIT_HASH=tcp-proxy

WORKDIR /build

ADD https://github.com/Bjorkan/ha-remoteterm-app/archive/refs/heads/tcp-proxy.tar.gz /tmp/remoteterm.tar.gz

RUN tar -xzf /tmp/remoteterm.tar.gz --strip-components=1 -C /build
RUN cd frontend && npm ci
RUN cd frontend && VITE_COMMIT_HASH="${REMOTETERM_COMMIT_HASH}" npm run build

FROM python:3.13-slim

ARG REMOTETERM_COMMIT_HASH=tcp-proxy

WORKDIR /app

ENV COMMIT_HASH="${REMOTETERM_COMMIT_HASH}"

COPY --from=ghcr.io/astral-sh/uv:0.6 /uv /usr/local/bin/uv
COPY --from=frontend-builder /build/pyproject.toml /build/uv.lock ./
RUN uv sync --frozen --no-dev

COPY --from=frontend-builder /build/app/ ./app/
COPY --from=frontend-builder /build/LICENSES.md ./
COPY --from=frontend-builder /build/frontend/dist ./frontend/dist

RUN mkdir -p /app/data /data

EXPOSE 8000 5001

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
