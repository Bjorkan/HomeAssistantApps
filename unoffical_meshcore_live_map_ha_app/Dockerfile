ARG BUILD_FROM
FROM $BUILD_FROM

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        nodejs \
        npm \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/yellowcooln/meshcore-mqtt-live-map /opt/meshcore-mqtt-live-map

WORKDIR /opt/meshcore-mqtt-live-map/backend

RUN pip install --no-cache-dir -r requirements.txt \
    && npm install --prefix /opt/meshcore-mqtt-live-map/backend @michaelhart/meshcore-decoder \
    && npm cache clean --force

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8080
ENTRYPOINT ["/run.sh"]
