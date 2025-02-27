#!/bin/sh
##
# LocalGov Drupal Azure Web App container.
#
# Container entry point.
set -e

# Inject environmental vaiables.
echo "# Azure database variables" >> /etc/apache2/envvars
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/apache2/envvars
echo "# Azure database variables" >> /etc/profile
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/profile

# Ensure Drupal directories are in place.
mkdir -p /var/www/share/private
mkdir -p /var/www/share/public
ln -snf  /var/www/share/public /var/www/html/web/sites/default/files

# Start SSH and Apache.
service ssh start
/usr/sbin/apache2ctl -D FOREGROUND
