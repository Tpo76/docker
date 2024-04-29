#!/bin/bash

set -x

echo -e "mda \"procmail -d %T\"\nhostname = ${SMTP_ADDR}" > /etc/esmtprc


rpm -ivh --nodeps centreon-engine*.rpm centreon-engine-daemon*.rpm centreon-broker-core*.rpm centreon-broker-cbmod*.rpm centreon-perl-libs*.rpm centreon-common*.rpm centreon-broker*.rpm centreon-perl-libs*.rpm
# rm -f *.rpm

su centreon-engine -s /bin/bash -c "touch /etc/centreon-engine/signal"
cp /usr/sbin/centengine /usr/local/share/applications/
cp /usr/sbin/centenginestats /usr/local/share/applications/

exec "$@"