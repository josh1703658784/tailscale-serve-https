ARG TAG=dummy
FROM tailscale/tailscale:${TAG}

RUN apk update && apk add bash

COPY ./run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

ENTRYPOINT [ "bash", "/usr/local/bin/run" ]
