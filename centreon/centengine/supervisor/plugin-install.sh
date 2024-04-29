#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/etc/centreon-engine/plugins.json"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    sudo /usr/local/bin/gorgone_install_plugins.pl --type=rpm $(jq -r 'keys[]' $CONFIG_FILE)
done