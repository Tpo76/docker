FROM docker.io/library/almalinux:8

ARG TZ SMTP_ADDR VERSION

ENV TZ=${TZ} SMTP_ADDR=${SMTP_ADDR} VERSION=${VERSION}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/${VERSION}/el8/centreon-${VERSION}.repo && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf config-manager -y --set-enabled 'powertools'
   
RUN dnf install -y mariadb \
    centreon-clib \
    nc \
    sudo \
    perl-XML-Simple \
    perl-XML-LibXML-Simple \
    perl-Net-SNMP \
    perl-Libssh-Session \
    net-snmp-perl \
    rrdtool-perl \
    mailx \
    procmail \
    esmtp \
    supervisor \
    inotify-tools \
    perl-Net-Curl bzip2 perl-Clone perl-Digest-MD5-File perl-Mojolicious 'perl(Hash::Merge)' 'perl(JSON::PP)' 'perl(NetAddr::IP)' 'perl(Schedule::Cron)' 'perl(Crypt::CBC)' 'perl(CryptX)' 'perl(YAML)' 'perl(DBD::SQLite)' 'perl(DBD::mysql)' 'perl(HTTP::Daemon::SSL)' 'perl(HTTP::Status)' 'perl(MIME::Base64)' 'perl(ZMQ::FFI)' 'perl(EV)' 'perl(JSON::XS)' 'perl(YAML::LibYAML)' && \
    dnf download centreon-gorgone-centreon-config centreon-common centreon-gorgone

RUN groupadd -g 6000 centreon && \
    useradd -u 6000 -g centreon -m -r -d /var/spool/centreon -c "Centreon" -s /bin/bash centreon && \
    groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker && \
    groupadd -g 6003 centreon-gorgone && \
    useradd -u 6003 -g centreon-gorgone -m -r -d /var/lib/centreon-gorgone -c "Centreon Gorgone"  -s /bin/bash centreon-gorgone && \
    usermod -a -G centreon-engine centreon-gorgone

COPY supervisor /tmp/supervisord
COPY scripts /tmp/scripts

RUN cp /tmp/supervisord/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    cp /tmp/supervisord/config-reloader.sh /usr/local/bin/config-reloader.sh && \
    cp /tmp/supervisord/docker-entrypoint.sh /usr/local/bin/ && \
    chmod +x /usr/local/bin/config-reloader.sh /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/ && \
    cp /tmp/scripts/sudo-centreon /etc/sudoers.d/centreon && \
    cp /tmp/scripts/service /usr/bin/service && \
    cp /tmp/scripts/run_save_discovered_host /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/ && \
    ln -nsf /usr/local/share/applications/centenginestats /usr/sbin/ && \
    chmod +x /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/run_save_discovered_host \
    /usr/bin/service

RUN dnf clean all && \
    rm -rf /var/cache/dnf \
    rm -rf /tmp/scripts \
    /tmp/supervisord

ENTRYPOINT [ "docker-entrypoint.sh" ]
    
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
