#!/bin/bash

set -x

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
	echo "Centreon databse $RET detected"
    RPM_VERSION=$(ls centreon-web* | awk -F- '{print $3}')
    if [ $RPM_VERSION = $RET ]; then
        echo "Centreon version $RET already installed"
        echo "date.timezone =  ${TZ}" >> /etc/php.d/50-centreon.ini
        if [ -d /usr/share/centreon/www/install/ ]; then
          mv /usr/share/centreon/www/install/ /var/lib/centreon/installs/install-$(date +%Y%m%d_%H%M%S)-$(shuf -i1-1000000 -n1)
        fi
    else
        echo "Centreon version $RET already installed"
        echo "Centreon version $RPM_VERSION will be installed"
        rpm -ivh --nodeps centreon-common*.rpm centreon-perl-libs*.rpm centreon-poller*.rpm centreon-web*.rpm centreon-license-manager-common*.rpm centreon-license-manager*.rpm centreon-auto-discovery-server*.rpm centreon-pp-manager*.rpm centreon-it-edition-extensions*.rpm
        echo "date.timezone =  ${TZ}" >> /etc/php.d/50-centreon.ini
    fi
else
    rpm -ivh --nodeps centreon-common*.rpm centreon-perl-libs*.rpm centreon-poller*.rpm centreon-web*.rpm centreon-license-manager-common*.rpm centreon-license-manager*.rpm centreon-auto-discovery-server*.rpm centreon-pp-manager*.rpm centreon-it-edition-extensions*.rpm 
    echo "date.timezone =  ${TZ}" >> /etc/php.d/50-centreon.ini
fi

mkdir -p /usr/share/centreon/lib/centreon-broker
su apache -s /bin/bash -c "touch /etc/centreon-engine/plugins.json"
touch /var/log/centreon/centreon-web.log
chown apache. /var/log/centreon/centreon-web.log
chmod 1230 /var/log/centreon/centreon-web.log
su - apache -s /bin/bash -c "/usr/share/centreon/bin/console cache:clear"

rm -f *.rpm
rm -rf /tmp/install/
unset MYSQL_ROOT_PASSWORD

exec "$@"