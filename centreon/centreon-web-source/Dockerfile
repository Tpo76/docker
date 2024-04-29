FROM almalinux:8

RUN dnf install -y epel-release dnf-plugins-core git sqlite && \
    dnf update -y && \
    dnf config-manager --set-enabled 'powertools' && \
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf config-manager --add-repo https://packages.centreon.com/rpm-standard/23.10/el8/centreon-23.10.repo && \
    dnf module install -y php:remi-8.1 && \
    dnf install -y \
    cpp \
    dmidecode \
    fping \
    freetds \
    gcc \
    gcc-c++ \
    glib2-devel \
    gnutls \
    gnutls-devel \
    httpd \
    libstdc++ \
    lm_sensors \
    lua \
    lua-devel \
    mailx \
    make \
    net-snmp \
    net-snmp-libs \
    net-snmp-perl \
    net-snmp-utils \
    net-tools \
    openssl \
    openwsman-perl \
    perl \
    perl-Crypt-DES \
    perl-DBD-MySQL \
    perl-DBI \
    perl-DateTime \
    perl-DateTime-Format-Duration-ISO8601 \
    perl-Digest-HMAC \
    perl-Digest-SHA1 \
    perl-Encode \
    perl-interpreter \
    perl-IO-Socket-INET6 \
    perl-JSON \
    perl-MQSeries \
    perl-MongoDB \
    perl-Net-Curl \
    perl-Redis \
    perl-Socket \
    perl-Socket6 \
    perl-Sys-Syslog \
    perl-URI \
    perl-UUID \
    perl-rrdtool \
    php \
    php-cli \
    php-common \
    php-devel \
    php-fpm \
    php-gd \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mysqlnd \
    php-pdo \
    php-pear \
    php-process \
    php-snmp \
    php-xml \
    php-zip \
    plink \
    quota \
    rrdtool \
    rrdtool-devel \
    unixODBC
    
RUN /bin/pear channel-update pear.php.net && \
    /bin/pear upgrade-all && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

ENV COMPOSER_ALLOW_SUPERUSER=1 PUPPETEER_SKIP_DOWNLOAD=1 NVM_DIR=/root/.nvm

RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&\
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install 20 && \
    npm install -g npm@10.5.2 && \
    # npm cache clean --force && \
    npm install -g pnpm
    # npm install -g npm@10.5.2

RUN git clone -b centreon-web-23.10.11 https://github.com/centreon/centreon.git

# RUN clear && \
#     source ~/.bashrc

WORKDIR /centreon/centreon/


RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&\
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    composer install --no-dev --optimize-autoloader && \
    $(command -v pnpm) install && \
    $(command -v pnpm) run build

COPY install-var.txt /tmp/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
