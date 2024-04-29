#!/bin/bash

set -x

cd /tmp/git/gorgone/centreon-gorgone/
./install.sh -i -s

exec "$@"