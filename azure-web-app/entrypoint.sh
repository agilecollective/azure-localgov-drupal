#!/bin/sh
##
# LocalGov Drupal Azure Web App container.
#
# Container entry point.
set -e

echo "# Azure database variables" >> /etc/apache2/envvars
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/apache2/envvars
echo "# Azure database variables" >> /etc/profile
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/profile

service ssh start
/usr/sbin/apache2ctl -D FOREGROUND
