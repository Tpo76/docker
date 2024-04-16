#!/bin/bash

set -x

mkdir -p /etc/centreon-gorgone/config.d/
mkdir -p /etc/centreon/license.d/
cp /tmp/install/config.yaml /etc/centreon-gorgone/config.yaml
cp /tmp/install/autoinstall.php /usr/share/centreon/autoinstall.php
cp -r /tmp/install/configuration/* /usr/share/centreon/www/install/tmp/

touch /var/log/centreon/centreon-web.log

chmod 775 /etc/centreon-broker
chmod 1230 /var/log/centreon/centreon-web.log
chown apache. /var/log/centreon/centreon-web.log
chown -R centreon-gorgone. /etc/centreon-gorgone/
chown centreon-broker. /etc/centreon-broker


if [ -d /usr/share/centreon/www/install/ ] &&  [ -f /etc/centreon/centreon.conf.php ]; then
	mv /usr/share/centreon/www/install/ /var/lib/centreon/installs/install-$(date +%Y%m%d_%H%M%S)-$(shuf -i1-1000000 -n1)
else
    echo "Waiting for database init..."
    while : ; do
    RET=$(mysql -p${MYSQL_ROOT_PASSWORD} -h database information_schema -N -s -r -e "select count(*) from information_schema.SCHEMATA;")
        EXEC=$?
        [[ $EXEC = 0 && $RET != 0 ]] && break
        echo "  Still waiting for database init... $RET"
        sleep 5
    done
    echo "  Done"
    /tmp/install/fresh.sh
fi

unset MYSQL_ROOT_PASSWORD

exec "$@"