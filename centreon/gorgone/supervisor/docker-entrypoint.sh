#!/bin/bash

set -x

echo -e "mda \"procmail -d %T\"\nhostname = ${SMTP_ADDR}" > /etc/esmtpr

rpm -ivh --nodeps centreon-gorgone-centreon-config*.rpm centreon-common*.rpm centreon-gorgone*.rpm

cp /usr/local/bin/gorgone_install_plugins.pl /usr/local/share/applications/

su centreon-gorgone -s /bin/bash -c "touch /var/cache/centreon-gorgone/disco"
su centreon-engine -s /bin/bash -c "touch /etc/centreon-engine/signal"
su centreon-broker -s /bin/bash -c "touch /etc/centreon-broker/signal"

su centreon-gorgone -s /bin/bash -c "echo 'restart' > /etc/centreon-engine/signal"
su centreon-gorgone -s /bin/bash -c "echo 'restart' > /etc/centreon-broker/signal"

rm -f *.rpm

exec "$@"