#!/bin/sh

set -e
set -x

#========= begin of function log()
# print out the message according to the level
# with timestamp
#
# usage:
# log "$LOG_LEVEL" "$message" ($LOG_LEVEL = DEBUG|INFO|WARN|ERROR)
#
# example:
# log "DEBUG" "This is a DEBUG_LOG_LEVEL message"
# log "INFO" "This is a INFO_LOG_LEVEL message"
#
function log() {

	TIMESTAMP=$(date)

	if [[ -z "${1}" || -z "${2}" ]]; then
		echo "${TIMESTAMP} - ERROR: Missing argument"
		echo "${TIMESTAMP} - ERROR: Usage log \"INFO\" \"Message log\" "
		exit 1
	fi

	# get the message log level
	log_message_level="${1}"

	# shift once to get the log message (string or array)
	shift

	# get the log message (full log message)
	log_message="${@}"

	echo -e "${TIMESTAMP} - $log_message_level - $log_message"

}
#======== end of function log()

#========= begin of function install_wizard_post()
# execute a post request of the install wizard
# - session cookie
# - php command
# - request body
function install_wizard_post() {
	log "INFO" " wizard install step ${2} response ->  $(curl -s -o /dev/null -w "%{http_code}" "http://apache/centreon/install/steps/process/${2}" \
		-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
		-H "Cookie: ${1}" --data "${3}")"
}
#========= end of function install_wizard_post()

#========= begin of function play_install_wizard()
function play_install_wizard() {
	log "INFO" "Playing install wizard"

    DATA_ENGINE=$(cat /tmp/install/configuration/engine.json | jq -r 'to_entries | map("\(.key)=\(.value|@uri)") | join("&")')
    DATA_BROKER=$(cat /tmp/install/configuration/broker.json | jq -r 'to_entries | map("\(.key)=\(.value|@uri)") | join("&")')
    DATA_ADMIN=$(cat /tmp/install/configuration/admin.json | jq -r 'to_entries | map("\(.key)=\(.value|@uri)") | join("&")')
    DATA_DATABASE=$(cat /tmp/install/configuration/database.json | jq -r 'to_entries | map("\(.key)=\(.value|@uri)") | join("&")')

	sessionID=$(curl -s -v "http://apache/centreon/install/install.php" 2>&1 | grep Set-Cookie | awk '{print $3}')
	curl -s "http://apache/centreon/install/steps/step.php?action=stepContent" -H "Cookie: ${sessionID}" >/dev/null
	install_wizard_post ${sessionID} "process_step3.php" "$DATA_ENGINE"
	install_wizard_post ${sessionID} "process_step4.php" "$DATA_BROKER"
	install_wizard_post ${sessionID} "process_step5.php" "$DATA_ADMIN"
	install_wizard_post ${sessionID} "process_step6.php" "$DATA_DATABASE"
	install_wizard_post ${sessionID} "configFileSetup.php"
	install_wizard_post ${sessionID} "installConfigurationDb.php"
	install_wizard_post ${sessionID} "installStorageDb.php"
	install_wizard_post ${sessionID} "createDbUser.php"
	install_wizard_post ${sessionID} "insertBaseConf.php"
	install_wizard_post ${sessionID} "partitionTables.php"
	install_wizard_post ${sessionID} "generationCache.php"
	install_wizard_post ${sessionID} "process_step8.php" 'modules%5B%5D=centreon-license-manager&modules%5B%5D=centreon-pp-manager&modules%5B%5D=centreon-autodiscovery-server&widgets%5B%5D=engine-status&widgets%5B%5D=global-health&widgets%5B%5D=graph-monitoring&widgets%5B%5D=grid-map&widgets%5B%5D=host-monitoring&widgets%5B%5D=hostgroup-monitoring&widgets%5B%5D=httploader&widgets%5B%5D=live-top10-cpu-usage&widgets%5B%5D=live-top10-memory-usage&widgets%5B%5D=service-monitoring&widgets%5B%5D=servicegroup-monitoring&widgets%5B%5D=tactical-overview&widgets%5B%5D=single-metric'
	install_wizard_post ${sessionID} "process_step9.php" 'send_statistics=0'
}
#========= end of function play_install_wizard()

play_install_wizard

DB_ROOT_PWD=${MYSQL_ROOT_PASSWORD}
DB_USER=$(grep mysql_user /etc/centreon/conf.pm | cut -d\" -f2)
DB_PASSWORD=$(grep mysql_passwd /etc/centreon/conf.pm | cut -d\' -f2)
CENTREON_DB=$(grep mysql_database_oreon /etc/centreon/conf.pm | cut -d\" -f2)
CENTSTORAGE_DB=$(grep mysql_database_ods /etc/centreon/conf.pm | cut -d\" -f2)

GORGONE_USR=$(grep username /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2| head -n 1)
GORGONE_PWD=$(grep password /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2 | head -n 1)

mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTREON_DB.* to '$DB_USER'@'%' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database -N -s -r -e "GRANT ALL PRIVILEGES on $CENTSTORAGE_DB.* to '$DB_USER'@'%' identified by '$DB_PASSWORD'"
mysql -p$DB_ROOT_PWD -h database $CENTREON_DB -N -s -r -e "update cfg_centreonbroker_info set config_value='cbd' where config_id in (select config_id from cfg_centreonbroker_info where config_value = 'central-module-master-output') and config_key = 'host'"
mysql -p$DB_ROOT_PWD -h database $CENTREON_DB -N -s -r -e "update options set \`value\`='gorgone' where \`key\`='gorgone_api_address'"

sed -i "s/127.0.0.1/apache/"  /etc/centreon-gorgone/config.d/31-centreon-api.yaml
sed -i "s/- 127.0.0.1\/32$/- 0.0.0.0\/0/"  /etc/centreon-gorgone/config.d/40-gorgoned.yaml
