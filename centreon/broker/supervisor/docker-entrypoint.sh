#!/bin/bash

set -x

rpm -ivh --nodeps centreon-broker*.rpm centreon-broker-core*.rpm centreon-broker-cbd*.rpm

su centreon-broker -s /bin/bash -c "touch /etc/centreon-broker/signal"
rm -f *.rpm

exec "$@"