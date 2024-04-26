FROM docker.io/library/almalinux:8


ARG TZ

ENV TZ=${TZ}

RUN dnf update -y && \
    dnf install -y httpd

COPY 10-centreon.conf /etc/httpd/conf.d/

RUN mkdir -p /var/log/centreon/symfony && \
    chown apache. /var/log/centreon/symfony

RUN dnf clean all && \
    rm -rf /var/cache/dnf

CMD ["bash", "-c", "/usr/sbin/httpd -DFOREGROUND"]
