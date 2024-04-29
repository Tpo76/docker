#!/bin/bash

# Define path to the configuration file
CONFIG_FILE="/etc/centreon-broker/signal"

# Monitor for changes to the configuration file
while true; do
    inotifywait -e modify "$CONFIG_FILE"
    value=$(cat $CONFIG_FILE)
    echo "Detected $value signal..."
    if [ "$value" = "reload" ]; then
        echo "Reloading cbwd..."
        kill -SIGHUP $(pgrep cbwd)
    elif [ $value = "restart" ]; then
        echo "Restarting centengin..."
        supervisorctl restart cbwd
    else
        echo "Unknown signal: $value"
    fi
done