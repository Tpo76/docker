FROM alpine:latest

ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

RUN apk add curl mysql-client python3 jq

COPY install /tmp/install

RUN chmod +x /tmp/install/*.sh && \
    cp /tmp/install/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

# CMD ['sh', '-c', 'while true; do sleep 1000; done;']