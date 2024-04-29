FROM docker.io/library/almalinux:8


ARG TZ

ENV TZ=${TZ}

RUN dnf update -y && \
    dnf install -y httpd

COPY app/ /app

RUN mkdir -p /var/log/centreon/symfony && \
    mkdir -p /usr/share/centreon/www/ && \
    chown apache. /var/log/centreon/symfony && \
    ln -nsf /app/10-centreon.conf /etc/httpd/conf.d/ && \
    cp /app/maintenance.html /var/www/html/index.html


RUN dnf clean all && \
    rm -rf /var/cache/dnf

CMD ["bash", "-c", "/usr/sbin/httpd -DFOREGROUND"]
