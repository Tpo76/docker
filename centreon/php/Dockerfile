FROM almalinux:8

ARG TZ MYSQL_ROOT_PASSWORD

ENV TZ=${TZ} MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf install -y mariadb && \
    dnf config-manager --nogpgcheck --set-enabled 'powertools' && \
    dnf module reset php -y --nogpgcheck && \
    dnf module install php:remi-8.1 -y --nogpgcheck && \
    dnf install -y supervisor \
    inotify-tools \
    nagios-common \
    bind-utils \
    'perl(DBI)' \
    'perl(FindBin)' \
    'perl(Getopt::Long)' \
    'perl(IO::Handle)' \
    'perl(POSIX)' \
    'perl(Pod::Usage)' \
    'perl(Sys::Syslog)' \
    centreon-clib \
    bc \
    brotli \
    openssl \
    perl-DBD-MySQL \
    perl-DBI \
    perl-HTML-Parser \
    curl \
    php-cli php-common php-curl php-fpm php-gd php-intl php-json php-ldap php-mbstring php-mysqlnd php-pdo php-pear php-snmp php-xml php-zip rrdtool rrdtool-perl rsync systemd php-sourceguardian-loader php-pecl-gnupg &&\
    dnf download centreon-perl-libs centreon-web centreon-common centreon-poller centreon-widget\* centreon-license-manager-common centreon-auto-discovery-server centreon-license-manager centreon-pp-manager

### Pack installation can be comment if not needed
RUN dnf config-manager --add-repo https://packages.centreon.com/rpm-connectors/2e83f5ff110c44a9cab8f8c7ebbe3c4f/el8/centreon-connectors.repo

COPY install /tmp/install/
COPY app/ /app

RUN groupadd -g 6000 centreon && \
    useradd -u 6000 -g centreon -m -r -d /var/spool/centreon -c "Centreon" -s /bin/bash centreon && \
    groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker && \
    groupadd -g 6003 centreon-gorgone && \
    useradd -u 6003 -g centreon-gorgone -m -r -d /var/lib/centreon-gorgone -c "Centreon Gorgone"  -s /bin/bash centreon-gorgone && \
    usermod -aG centreon apache

RUN mkdir /run/php-fpm/ && \
    ln -nsf /app/supervisord.conf /etc/supervisord.d/supervisord.conf && \
    ln -nsf /app/centreon.conf /etc/php-fpm.d/centreon.conf && \
    cp /tmp/install/config-reloader.sh /usr/local/bin/ && \
    cp /tmp/install/docker-entrypoint.sh /usr/local/bin/ && \
    ln -nsf /usr/local/share/applications/centengine /usr/sbin/ && \
    mkdir -p /var/log/centreon/symfony /etc/centreon-broker && \
    chown -R apache. /var/log/centreon/symfony && \
    chmod +x /tmp/install/*.sh /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh

RUN dnf clean all && \
    rm -rf /var/cache/dnf

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.d/supervisord.conf"]
