FROM almalinux:8

ARG TZ POD_ENGINE POD_SOCK MYSQL_ROOT_PASSWORD

ENV TZ=${TZ} POD_ENGINE=${POD_ENGINE} POD_SOCK=${POD_SOCK} MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
    podman && \
    dnf install -y mariadb && \
    dnf config-manager --nogpgcheck --set-enabled 'powertools' && \
    dnf module reset php -y --nogpgcheck && \
    dnf module install php:remi-8.1 -y --nogpgcheck && \
    dnf install -y centreon-web centreon-license-manager-common centreon-widget\* centreon-auto-discovery-server && \
    dnf install -y bind-utils &&\  
    rpm --erase --nodeps --verbose $(rpm -qa | grep -v centreon-gorgone-centreon-config | grep -e 'centreon-broker' -e 'centreon-plugin' -e 'centreon-gorgone' -e 'centreon-poller' -e 'centreon-connector' -e 'centreon-engine' -e 'nagios')

### Pack installation can be comment if not needed
RUN dnf config-manager --add-repo https://packages.centreon.com/rpm-connectors/2e83f5ff110c44a9cab8f8c7ebbe3c4f/el8/centreon-connectors.repo && \
    dnf install -y centreon-pack\* --nogpgcheck 

COPY install /tmp/install/

RUN mkdir /run/php-fpm/ && \
    # mkdir -p /etc/centreon-gorgone/config.d/ && \
    # mkdir -p /etc/centreon/license.d/ && \
    echo "date.timezone =  ${TZ}" >> /etc/php.d/50-centreon.ini && \
#    cp /tmp/install/centengine /usr/sbin/centengine && \
    cp /tmp/install/centreon.conf /etc/php-fpm.d/centreon.conf && \
    # cp /tmp/install/podman-signal /usr/bin/service && \
    # cp /tmp/install/config.yaml /etc/centreon-gorgone/config.yaml && \
    # cp /tmp/install/autoinstall.php /usr/share/centreon/autoinstall.php && \
    cp /tmp/install/docker-entrypoint.sh /usr/local/bin/ && \
    # cp -r /tmp/install/configuration/* /usr/share/centreon/www/install/tmp/ && \
    cp /tmp/install/sudo-centreon /etc/sudoers.d/centreon && \
    ln -nsf /usr/local/share/applications/centengine /usr/sbin/ && \
    mkdir -p /var/log/centreon/symfony /etc/centreon-broker && \
    chown -R apache. /var/log/centreon/symfony && \
    # chown centreon. /etc/centreon/license.d/ && \
    # chmod +x /usr/bin/service /tmp/install/*.sh /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /tmp/install/*.sh /usr/local/bin/docker-entrypoint.sh && \
    # chmod 775 /etc/centreon/license.d/ && \
    ln -s /usr/local/bin/docker-entrypoint.sh
    # chmod 775 /etc/centreon-broker && \
    # chown -R centreon-gorgone. /etc/centreon-gorgone/ && \
    # chown centreon-broker. /etc/centreon-broker

RUN dnf clean all && \
    rm -rf /var/cache/dnf

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "/usr/sbin/php-fpm --nodaemonize"]
