ARG TAG=dummy
FROM tailscale/tailscale:${TAG}

COPY init-serve-config.sh /usr/local/bin

RUN chmod +x /usr/local/bin/init-serve-config.sh && ln -s /usr/local/bin/init-serve-config.sh /usr/local/bin/init-serve-config

ENV TS_SERVE_CONFIG=/tmp/config

CMD ["sh", "-c", "/usr/local/bin/init-serve-config && /usr/local/bin/containerboot"]
