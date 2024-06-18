#!/bin/sh

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

if [[ $EXEC = 0 && $RET != 0 ]]; then
	echo "Centreon database $RET detected"
    OUTPUT=$(curl  'http://apache/centreon/api/latest/platform/installation/status' --header 'Accept: application/json')
    IS_INSTALLED=$(echo $OUTPUT | jq -r '.is_installed')
    UPGRADE=$(echo $OUTPUT | jq -r '.has_upgrade_available') 
    if [[ "$IS_INSTALLED" = "true" && "$UPGRADE" = "false" ]]; then
        echo "Centreon is already installed"
    elif [[ "$IS_INSTALLED" = "true" && "$UPGRADE" = "true" ]]; then
        echo "Centreon version $RET already installed"
        echo "Upgrade available"
        sleep 5
        /tmp/install/update.sh
    fi
else
    while : ; do
        OUTPUT=$(curl  'http://apache/centreon/api/latest/platform/installation/status' --header 'Accept: application/json')
        IS_INSTALLED=$(echo $OUTPUT | jq -r '.is_installed')
        [[ "$IS_INSTALLED" = "false" ]] && break
        echo "  Still waiting for Centreon installation..."
        sleep 5
    done
    python3 /tmp/install/update_json.py
    cat /tmp/install/configuration/database.json
    # cp /tmp/install/autoinstall.php /usr/share/centreon/autoinstall.php
    # cp -r /tmp/install/configuration/* /usr/share/centreon/www/install/tmp/
    sleep 5
    /tmp/install/fresh.sh
fi

exit 0