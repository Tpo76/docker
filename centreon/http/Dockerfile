FROM docker.io/library/almalinux:8


ARG TZ POD_PHP POD_ENGINE POD_SOCK

ENV TZ=${TZ} POD_PHP=${POD_PHP} POD_ENGINE=${POD_ENGINE} POD_SOCK=${POD_SOCK}

RUN dnf update -y && \
    dnf install -y httpd

COPY 10-centreon.conf /etc/httpd/conf.d/

RUN mkdir -p /var/log/centreon/symfony && \
    chown apache. /var/log/centreon/symfony 
#    printenv | grep POD | awk  '{print "export " $1}' > /etc/environment

RUN dnf clean all && \
    rm -rf /var/cache/dnf

CMD ["bash", "-c", "/usr/sbin/httpd -DFOREGROUND"]
