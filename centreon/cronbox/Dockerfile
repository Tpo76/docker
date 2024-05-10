FROM almalinux:8

ARG TZ VERSION

ENV TZ=${TZ} VERSION=${VERSION}

RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/${VERSION}/el8/centreon-${VERSION}.repo && \
    dnf module install php:remi-8.1 -y && \
    dnf install -y php-pdo \
    php-mysqlnd \
    procps-ng \
    perl \
    perl-DBI \
    perl-DBD-MySQL && \
    dnf download centreon-perl-libs && \
    rpm -ivh --nodeps *.rpm

RUN echo "date.timezone = ${TZ}" > /etc/php.d/00-timezone.ini && \
    sed -i 's/my \$pid = defined(\$data->{pid}) ? \$data->{pid} : -1;/my \$pid = -1;/g' /usr/share/perl5/vendor_perl/centreon/common/lock.pm

RUN dnf clean all && \
    rm -rf /var/cache/dnf \
    rm *.rpm -f

CMD ["/usr/bin/bash"]