#!/bin/sh

set -e
set -x

php /tmp/install/configuration/update-centreon.php -c /etc/centreon/centreon.conf.php
rm -rf /usr/share/centreon/www/install
