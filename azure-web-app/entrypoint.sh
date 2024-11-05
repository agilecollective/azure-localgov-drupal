#!/bin/sh
##
# LocalGov Drupal Azure Web App container.
#
# Container entry point.
set -e

echo "# Azure environment variables" >> /etc/profile
printenv | grep AZURE | awk '{print "export "$0}' >> /etc/profile

service ssh start
/usr/sbin/apache2ctl -D FOREGROUND
