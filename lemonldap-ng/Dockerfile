FROM centos:7
MAINTAINER Fabien THEPAUT

ENV SSODOMAIN centreon.com
ENV container docker

COPY lemonldap-ng.repo /etc/yum.repos.d/

RUN yum install wget -y

RUN wget http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-OW2

RUN yum clean all && yum update -y && yum install epel-release -y && yum install -y lemonldap-ng.noarch lemonldap-ng-doc.noarch

RUN sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl


COPY lemonldap-ng.ini /etc/lemonldap-ng/
RUN chown root.apache /etc/lemonldap-ng/lemonldap-ng.ini && chmod 640 /etc/lemonldap-ng/lemonldap-ng.ini
COPY centreon.conf /etc/lemonldap-ng/

RUN ln -s /etc/lemonldap-ng/centreon.conf /etc/httpd/conf.d/
COPY lmConf-1.js /var/lib/lemonldap-ng/conf/
RUN chown apache. /var/lib/lemonldap-ng/conf/lmConf-1.js && chmod 640 /var/lib/lemonldap-ng/conf/lmConf-1.js

ENTRYPOINT ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

EXPOSE 80 443
VOLUME ["/var/log/httpd", "/etc/httpd", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]

