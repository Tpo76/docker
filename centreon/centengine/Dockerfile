FROM docker.io/library/almalinux:8

ARG TZ SMTP_ADDR VERSION
ENV TZ=${TZ} SMTP_ADDR=${SMTP_ADDR} VERSION=${VERSION}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/${VERSION}/el8/centreon-${VERSION}.repo && \
    dnf install -y dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y centreon-clib \
    nagios-common \
    nagios-plugins \
    nagios-plugins-icmp \
    nagios-plugins-dhcp \
    centreon-plugin-Applications-Databases-Mysql \
    centreon-plugin-Applications-Monitoring-Centreon-Central \
    centreon-plugin-Applications-Monitoring-Centreon-Database \
    centreon-plugin-Applications-Monitoring-Centreon-Map4-Jmx \
    centreon-plugin-Applications-Monitoring-Centreon-Poller \
    centreon-plugin-Applications-Protocol-Dns \
    centreon-plugin-Applications-Protocol-Ftp \
    centreon-plugin-Applications-Protocol-Http \
    centreon-plugin-Applications-Protocol-Ldap \
    centreon-plugin-Hardware-Printers-Generic-Snmp \
    centreon-plugin-Hardware-Ups-Standard-Rfc1628-Snmp \
    centreon-plugin-Network-Cisco-Standard-Snmp \
    centreon-plugin-Operatingsystems-Linux-Snmp \
    centreon-plugin-Operatingsystems-Windows-Snmp \
    jq \
    sudo \
    procps-ng \
    mailx \
    procmail \
    esmtp \
    supervisor \
    inotify-tools && \
    dnf install -y 'perl(DBI)' 'perl(FindBin)' 'perl(Getopt::Long)' 'perl(IO::Handle)' 'perl(POSIX)' 'perl(Pod::Usage)' 'perl(Sys::Syslog)' perl-Hash-Ordered perl-DBD-MySQL perl-DBD-SQLite && \
    dnf download centreon-engine centreon-engine-daemon centreon-broker-core centreon-broker-cbmod centreon-perl-libs centreon-common centreon-broker centreon-perl-libs

RUN groupadd -g 6000 centreon && \
    useradd -u 6000 -g centreon -m -r -d /var/spool/centreon -c "Centreon" -s /bin/bash centreon && \
    groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker && \
    groupadd -g 6003 centreon-gorgone && \
    useradd -u 6003 -g centreon-gorgone -m -r -d /var/lib/centreon-gorgone -c "Centreon Gorgone"  -s /bin/bash centreon-gorgone &&\
    usermod -a -G nagios centreon-engine && \
    usermod -a -G centreon centreon-broker

COPY supervisor /tmp/supervisord

RUN cp /tmp/supervisord/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    cp /tmp/supervisord/config-reloader.sh /usr/local/bin/config-reloader.sh && \
    cp /tmp/supervisord/plugin-install.sh /usr/local/bin/plugin-install.sh &&\
    cp /tmp/supervisord/docker-entrypoint.sh /usr/local/bin/ && \
    cp /tmp/supervisord/sudo-centreon-gorgone /etc/sudoers.d/centreon-gorgone && \
    chmod +x /usr/local/bin/config-reloader.sh /usr/local/bin/docker-entrypoint.sh /usr/local/bin/plugin-install.sh && \
    ln -nsf /usr/local/share/applications/gorgone_install_plugins.pl /usr/local/bin/ &&\
    ln -s /usr/local/bin/docker-entrypoint.sh

RUN dnf clean all && \
    rm -rf /var/cache/dnf \
    /tmp/supervisord

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
