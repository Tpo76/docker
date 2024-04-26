#!/bin/bash

set -x


# mkdir -p /etc/centreon-gorgone/config.d/
# # mkdir -p /etc/centreon/license.d/
# cp /tmp/install/config.yaml /etc/centreon-gorgone/config.yaml

touch /var/log/centreon/centreon-web.log

# chmod 775 /etc/centreon-broker
chmod 1230 /var/log/centreon/centreon-web.log
chown apache. /var/log/centreon/centreon-web.log
# chown -R centreon-gorgone. /etc/centreon-gorgone/
# chown centreon-broker. /etc/centreon-broker

echo "Waiting for database init..."
    while : ; do
        RET=$(mysql -p${MYSQL_ROOT_PASSWORD} -h database information_schema -N -s -r -e "select count(*) from information_schema.SCHEMATA;")
        EXEC=$?
        [[ $EXEC = 0 && $RET -ge 3 ]] && break
        echo "  Still waiting for database init... $RET"
        sleep 5
    done
echo "  Done"

RET=$(mysql -p${MYSQL_ROOT_PASSWORD} -h database centreon -N -s -r -e "select value from informations where \`key\` = 'version';")
EXEC=$?

if [ $EXEC = 0 ] &&  [ $RET != 0 ]; then
	echo "Centreon $RET detected"
    rpm -Uvh --nodeps centreon-common*.rpm centreon-perl-libs*.rpm centreon-poller*.rpm centreon-web*.rpm centreon-widget*.rpm centreon-license-manager-common*.rpm centreon-license-manager*.rpm centreon-auto-discovery-server*.rpm centreon-pp-manager*.rpm
    if [ -d /usr/share/centreon/www/install/ ]; then
        mv /usr/share/centreon/www/install/ /var/lib/centreon/installs/install-$(date +%Y%m%d_%H%M%S)-$(shuf -i1-1000000 -n1)
    fi
else
    rpm -ivh --nodeps centreon-common*.rpm centreon-perl-libs*.rpm centreon-poller*.rpm centreon-web*.rpm centreon-widget*.rpm centreon-license-manager-common*.rpm centreon-license-manager*.rpm centreon-auto-discovery-server*.rpm centreon-pp-manager*.rpm
    echo "date.timezone =  ${TZ}" >> /etc/php.d/50-centreon.ini
    cp /tmp/install/autoinstall.php /usr/share/centreon/autoinstall.php
    cp -r /tmp/install/configuration/* /usr/share/centreon/www/install/tmp/
    sleep 5
    /tmp/install/fresh.sh
fi

rm -f *.rpm
unset MYSQL_ROOT_PASSWORD

exec "$@"