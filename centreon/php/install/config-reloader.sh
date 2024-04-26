#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/var/cache/centreon-gorgone/disco"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    value=$(cat $CONFIG_FILE)
    /usr/share/centreon/www/modules/centreon-autodiscovery-server/script/run_save_discovered_host $value
done