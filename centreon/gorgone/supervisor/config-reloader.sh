#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/etc/centreon-gorgone/config.d/40-gorgoned.yaml"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    echo "Detected configuration file change. Restarting gorgoned..."
    supervisorctl restart gorgoned
done
