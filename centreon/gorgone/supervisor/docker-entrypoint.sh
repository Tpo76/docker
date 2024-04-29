#!/bin/bash

set -x

echo -e "mda \"procmail -d %T\"\nhostname = ${SMTP_ADDR}" > /etc/esmtpr

rpm -ivh --nodeps centreon-gorgone-centreon-config*.rpm centreon-common*.rpm centreon-gorgone*.rpm

cp /usr/local/bin/gorgone_install_plugins.pl /usr/local/share/applications/

su centreon-gorgone -s /bin/bash -c "touch /var/cache/centreon-gorgone/disco"
rm -f *.rpm

exec "$@"