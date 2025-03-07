#!/bin/bash
##
# LocalGov Drupal Azure Web App container.
#
# Container entry point.
set -e

# Inject environmental variables.
echo "# Azure database variables" >> /etc/apache2/envvars
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/apache2/envvars
echo "# Azure database variables" >> /etc/profile
printenv | grep AZURE_MYSQL | awk '{print "export "$0}' >> /etc/profile

# Ensure Drupal directories are in place.
mkdir -p /var/www/share/private
mkdir -p /var/www/share/public
ln -snf  /var/www/share/public /var/www/html/web/sites/default/files

# Run Drupal deploy if new build.
# cd /var/www/html
# DRUPAL_BULID_ID=$(bin/drush state:get azure_build_id)
# if [[ "$AZURE_BUILD_ID" != "$DRUPAL_BUILD_ID" ]]; then
#   bin/drush updatedb --no-cache-clear --yes
#   bin/drush cache:rebuild
#   #bin/drush config:import --yes
#   bin/drush cache:rebuild
#   bin/drush deploy:hook --yes
#   bin/drush state:set azure_build_id $AZURE_BUILD_ID --yes
# fi

# Start SSH and Apache.
service ssh start
/usr/sbin/apache2ctl -D FOREGROUND
