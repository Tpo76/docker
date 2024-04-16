#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/etc/centreon-broker/central-broker.json"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    echo "Detected configuration file change. Restarting cbd..."
    supervisorctl restart cbd
done
