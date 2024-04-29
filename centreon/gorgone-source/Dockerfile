FROM almalinux:8

RUN dnf install -y epel-release dnf-plugins-core git sqlite && \
    dnf update -y && \
    dnf config-manager --set-enabled 'powertools' && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf install -y 'perl(Hash::Merge)' 'perl(JSON::PP)' 'perl(NetAddr::IP)' 'perl(Schedule::Cron)' 'perl(Crypt::CBC)' 'perl(CryptX)' 'perl(YAML)' 'perl(DBD::SQLite)' 'perl(DBD::mysql)' 'perl(HTTP::Daemon::SSL)' 'perl(HTTP::Status)' 'perl(MIME::Base64)' 'perl(ZMQ::FFI)' 'perl(EV)' 'perl(JSON::XS)' 'perl(YAML::LibYAML)'

# RUN git clone -b centreon-web-23.10.11 https://github.com/centreon/centreon.git

# WORKDIR /tmp/git/centreon/centreon-gorgone

RUN groupadd -g 6001 centreon-engine && \
    useradd -u 6001 -g centreon-engine -m -r -d /var/lib/centreon-engine -c "Centreon Engine" -s /bin/bash centreon-engine && \
    groupadd -g 6002 centreon-broker && \
    useradd -u 6002 -g centreon-broker -m -r -d /var/lib/centreon-broker -c "Centreon Broker"  -s /bin/bash centreon-broker

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/usr/bin/perl", "/usr/bin/gorgoned", "--config=/etc/centreon-gorgone/config.yaml", "--logfile=/dev/stdout", "--severity=info"]

