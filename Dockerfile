FROM tailscale/tailscale:latest

# COPY init-serve-config /usr/local/bin/init-serve-config
# RUN chmod +x /usr/local/bin/init-serve-config
COPY init-serve-config.sh /usr/local/bin
RUN ln -s /usr/local/bin/init-serve-config.sh /usr/local/bin/init-serve-config
RUN chmod +x /usr/local/bin/init-serve-config.sh

ENV TS_SERVE_CONFIG=/tmp/config

CMD ["sh", "-c", "/usr/local/bin/init-serve-config && /usr/local/bin/containerboot"]
# CMD ["sh", "-c", "/usr/local/bin/init-serve-config && /usr/local/bin/containerboot"]
