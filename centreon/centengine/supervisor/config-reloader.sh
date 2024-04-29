#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/etc/centreon-engine/signal"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    value=$(cat $CONFIG_FILE)
    echo "Detected $value signal..."
    if [ "$value" = "reload" ]; then
        echo "Reloading centengine..."
        kill -SIGHUP $(pgrep centengine)
    elif [ $value = "restart" ]; then
        echo "Restarting centengin..."
        supervisorctl restart centengine
    else
        echo "Unknown signal: $value"
    fi
done