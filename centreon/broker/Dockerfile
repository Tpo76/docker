FROM docker.io/library/almalinux:8

ARG TZ VERSION

ENV TZ=${TZ} VERSION=${VERSION}


RUN dnf update -y && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/${VERSION}/el8/centreon-${VERSION}.repo && \
    dnf install -y procps-ng gnutls lua supervisor inotify-tools rrdtool centreon-clib && \
    dnf download centreon-broker centreon-broker-core centreon-broker-cbd
    
RUN groupadd -g 6000 centreon && \
    useradd -u 6000 -g centreon -m -r -d /var/spool/centreon -c "Centreon" -s /bin/bash centreon && \
    groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker && \
    groupadd -g 6003 centreon-gorgone && \
    useradd -u 6003 -g centreon-gorgone -m -r -d /var/lib/centreon-gorgone -c "Centreon Gorgone"  -s /bin/bash centreon-gorgone && \
    usermod -a -G centreon centreon-broker && \
    usermod -a -G centreon-broker centreon

COPY supervisor /tmp/supervisord

RUN cp /tmp/supervisord/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    cp /tmp/supervisord/config-reloader.sh /usr/local/bin/config-reloader.sh && \
    cp /tmp/supervisord/docker-entrypoint.sh /usr/local/bin/ && \
    chmod +x /usr/local/bin/config-reloader.sh /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh

RUN dnf clean all && \
    rm -rf /var/cache/dnf \
    /tmp/supervisord

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
