FROM docker.io/library/almalinux:8

ARG TZ POD_SOCK POD_ENGINE POD_PHP SMTP_ADDR

ENV TZ=${TZ} POD_SOCK=${POD_SOCK} POD_ENGINE=${POD_ENGINE} POD_PHP=${POD_PHP}

RUN dnf update -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf config-manager -y --set-enabled 'powertools' 
   
RUN dnf install -y centreon-gorgone.noarch \
    centreon-gorgone-centreon-config.noarch \
    centreon-clib \
    centreon-plugin-Applications-Nmap-Cli \
    centreon-plugin-Applications-Protocol-Snmp \
    mariadb \
    nc \
    sudo \
    perl-XML-LibXML \
    perl-Net-SNMP \
    net-snmp-perl \
    rrdtool-perl \
    podman \
    mailx \
    procmail \
    esmtp

RUN dnf deplist centreon-plugin\* | awk '/provider:/ {print $2}' | grep 'perl-' | sort -u | uniq | xargs dnf -y install && \
    dnf install -y centreon-plugin-Applications-Nmap-Cli centreon-plugin-Applications-Protocol-Snmp

COPY scripts /tmp/scripts

RUN mkdir -p /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/ && \
    cp /tmp/scripts/podman-signal /usr/bin/service && \
    cp /tmp/scripts/sudo-centreon /etc/sudoers.d/centreon && \
    cp /tmp/scripts/centenginestats /usr/sbin/centenginestats && \
    cp /tmp/scripts/run_save_discovered_host /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/ && \
    chmod +x /usr/bin/service \
    /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/run_save_discovered_host \
    /usr/sbin/centenginestats && \
    echo -e "mda \"procmail -d %T\"\nhostname = ${SMTP_ADDR}" > /etc/esmtpr

RUN dnf clean all && \
    rm -rf /var/cache/dnf && \
    rm -rf /tmp/scripts


CMD ["/usr/bin/perl", "/usr/bin/gorgoned", "--config=/etc/centreon-gorgone/config.yaml", "--logfile=/dev/stdout", "--severity=info"]
