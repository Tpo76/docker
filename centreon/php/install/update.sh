#!/bin/sh

set -e
set -x

cd /usr/share/centreon/www/install/steps/process
su apache -s /bin/bash -c "php /tmp/install/configuration/update-centreon.php -c /etc/centreon/centreon.conf.php"
mv /usr/share/centreon/www/install/ /var/lib/centreon/installs/install-$(date +%Y%m%d_%H%M%S)-$(shuf -i1-1000000 -n1)
