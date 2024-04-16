#!/bin/sh

set -e
set -x

cd /usr/share/centreon/www/install/steps/process
su apache -s /bin/bash -c "php configFileSetup.php"
su apache -s /bin/bash -c "php installConfigurationDb.php"
su apache -s /bin/bash -c "php installStorageDb.php"
su apache -s /bin/bash -c "php createDbUser.php"
su apache -s /bin/bash -c "SERVER_ADDR='127.0.0.1' php insertBaseConf.php"
su apache -s /bin/bash -c "php partitionTables.php"
su apache -s /bin/bash -c "php generationCache.php"
su apache -s /bin/bash -c "ls /usr/share/centreon/www/widgets/ | grep -v -e '.php' -e '\.' -e centreon | xargs -I % sh -c 'php /tmp/install/configuration/install-centreon-widget.php -b /usr/share/centreon/bootstrap.php -w %'"
#su apache -s /bin/bash -c "ls /usr/share/centreon/www/modules/ | grep -v '.html' | xargs -I % sh -c 'php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m %'"
su apache -s /bin/bash -c "php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-license-manager"
su apache -s /bin/bash -c "php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-pp-manager"
su apache -s /bin/bash -c "php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-autodiscovery-server"
# su apache -s /bin/bash -c 'php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-bi-server'
# su apache -s /bin/bash -c 'php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-map4-web-client'
# su apache -s /bin/bash -c 'php /tmp/install/configuration/install-centreon-module.php -b /usr/share/centreon/bootstrap.php -m centreon-bam-server'

DB_ROOT_PWD=${MYSQL_ROOT_PASSWORD}
DB_USER=$(grep mysql_user /etc/centreon/conf.pm | cut -d\" -f2)
DB_PASSWORD=$(grep mysql_passwd /etc/centreon/conf.pm | cut -d\' -f2)
CENTREON_DB=$(grep mysql_database_oreon /etc/centreon/conf.pm | cut -d\" -f2)
CENTSTORAGE_DB=$(grep mysql_database_ods /etc/centreon/conf.pm | cut -d\" -f2)

GORGONE_USR=$(grep username /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2| head -n 1)
GORGONE_PWD=$(grep password /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2 | head -n 1)

PHP_IP=$(mysql -p$DB_ROOT_PWD -h database mysql -N -s -r -e 'select host from user where user = "centreon"')
CBD_IP=$(dig cbd +short)
GORGONE_IP=$(dig gorgone +short)

# mysql -p$DB_ROOT_PWD -h database -N -s -r -e "RENAME USER 'centreon'@'$PHP_IP' TO 'centreon'@'php'"
mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTREON_DB.* to '$DB_USER'@'$CBD_IP' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTSTORAGE_DB.* to '$DB_USER'@'$CBD_IP' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTREON_DB.* to '$DB_USER'@'$GORGONE_IP' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTSTORAGE_DB.* to '$DB_USER'@'$GORGONE_IP' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database $CENTREON_DB -N -s -r -e "update cfg_centreonbroker_info set config_value='cbd' where config_id in (select config_id from cfg_centreonbroker_info where config_value = 'central-module-master-output') and config_key = 'host'"
mysql -p$DB_ROOT_PWD -h database $CENTREON_DB -N -s -r -e "update options set \`value\`='gorgone' where \`key\`='gorgone_api_address'"

sed -i "s/127.0.0.1/apache/"  /etc/centreon-gorgone/config.d/31-centreon-api.yaml
sed -i "s/- 127.0.0.1\/32$/- 127.0.0.1\/32\n          - $PHP_IP\/32/"  /etc/centreon-gorgone/config.d/40-gorgoned.yaml

mkdir -p /etc/centreon/license.d/

chown -R centreon-engine. /etc/centreon-engine
chown -R centreon-broker. /etc/centreon-broker
chown -R centreon. /etc/centreon/
chmod 775 /etc/centreon-broker
chmod 775 /etc/centreon/license.d/

su apache -s /bin/bash -c "centreon -u $GORGONE_USR -p '$GORGONE_PWD' -a POLLERGENERATE -v 1"

rm -rf /usr/share/centreon/www/install
