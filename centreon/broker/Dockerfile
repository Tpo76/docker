FROM docker.io/library/almalinux:8


RUN dnf update -y && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y centreon-broker centreon-broker-storage centreon-broker-core centreon-broker-cbd \
    supervisor inotify-tools rrdtool

COPY supervisor /tmp/supervisord

RUN cp /tmp/supervisord/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    cp /tmp/supervisord/config-reloader.sh /usr/local/bin/config-reloader.sh && \
    cp /tmp/supervisord/watchdog.json /etc/centreon-broker/watchdog.json && \
    chown centreon-broker. /etc/centreon-broker/watchdog.json && \
    chmod +x /usr/local/bin/config-reloader.sh

RUN dnf clean all && \
    rm -rf /var/cache/dnf

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
# CMD ["/usr/sbin/cbwd", "/etc/centreon-broker/watchdog.json"]
