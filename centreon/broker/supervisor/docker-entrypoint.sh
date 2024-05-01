#!/bin/bash

set -x

rpm -ivh --nodeps centreon-broker*.rpm centreon-broker-core*.rpm centreon-broker-cbd*.rpm

rm -f *.rpm

exec "$@"