FROM docker.io/library/almalinux:8

ARG TZ SMTP_ADDR
ENV TZ=${TZ}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y centreon-engine \
    centreon-broker-cbmod \
    nagios-plugins \
    nagios-plugins-icmp \
    nagios-common \
    nagios-plugins-dhcp \
    perl-Hash-Ordered \
    centreon-plugin-Applications-Monitoring-Centreon-Central \
    centreon-plugin-Applications-Monitoring-Centreon-Poller \
    centreon-perl-libs \
    mailx \
    procmail \
    esmtp \
    supervisor \
    inotify-tools


RUN dnf deplist centreon-plugin\* | awk '/provider:/ {print $2}' | grep 'perl-' | sort -u | uniq | xargs dnf -y install

RUN mkdir -p /var/lib/centreon/centplugins/ && \
    chmod 777 /etc/centreon-engine/ && \
    cp /usr/sbin/centengine /usr/local/share/applications/ && \
    echo -e "mda \"procmail -d %T\"\nhostname = ${SMTP_ADDR}" > /etc/esmtprc

## Remove unnecessary RPMS
#RUN rpm --erase --nodeps --verbose $(rpm -qa | grep centreon-gorgone)
COPY supervisor /tmp/supervisord

RUN cp /tmp/supervisord/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    cp /tmp/supervisord/config-reloader.sh /usr/local/bin/config-reloader.sh && \
    chmod +x /usr/local/bin/config-reloader.sh

RUN dnf clean all && \
    rm -rf /var/cache/dnf

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
# CMD ["/usr/sbin/centengine", "/etc/centreon-engine/centengine.cfg"]
