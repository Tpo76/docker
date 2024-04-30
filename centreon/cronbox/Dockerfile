FROM almalinux:8

ARG TZ

ENV TZ=${TZ}

RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf module install php:remi-8.1 -y && \
    dnf install -y php-pdo \
    php-mysqlnd \
    procps-ng \
    perl \
    perl-DBI \
    perl-DBD-MySQL && \
    dnf download centreon-perl-libs && \
    rpm -ivh --nodeps *.rpm

RUN dnf clean all && \
    rm -rf /var/cache/dnf \
    rm *.rpm -f

CMD ["/usr/bin/bash"]