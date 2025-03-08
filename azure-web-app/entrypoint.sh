#!/bin/bash
##
# LocalGov Drupal Azure Web App container.
#
# Container entry point.
set -e

# Number of DB dumps to keep.
KEEP_DB_DUMPS=3

# Inject environmental variables.
echo "# Azure database variables" >> /etc/apache2/envvars
printenv | grep AZURE | awk '{print "export "$0}' >> /etc/apache2/envvars
echo "# Azure database variables" >> /etc/profile
printenv | grep AZURE | awk '{print "export "$0}' >> /etc/profile

# Ensure Drupal directories are in place.
mkdir -p /var/www/share/db_dumps/deploy
mkdir -p /var/www/share/private
mkdir -p /var/www/share/public
ln -snf  /var/www/share/public /var/www/html/web/sites/default/files

# Run Drupal deploy if new build.
cd /var/www/html
if [[ $(bin/drush status --field=bootstrap) ]] && [[ -n "$AZURE_BUILD_ID" ]] && [[ $(bin/drush state:get azure_build_id) != "$AZURE_BUILD_ID" ]]; then

  echo "Backing up database"
  bin/drush sql-dump > "/var/www/share/db_dumps/deploy/$(date +'%Y-%m-%d-%H%M%S').sql"

  echo "Running Drupal deploy"
  bin/drush updatedb --no-cache-clear --yes
  bin/drush cache:rebuild
  if [ -f config/sync/core.extension.yml ]; then
    bin/drush config:import --yes
  fi
  bin/drush cache:rebuild
  bin/drush deploy:hook --yes
  bin/drush state:set azure_build_id $AZURE_BUILD_ID --yes

  echo "Cleaning up old DB dumps"
  cd /var/www/share/db_dumps/deploy
  rm `ls -r | awk "NR>${KEEP_DB_DUMPS}"`
fi

# Start SSH and Apache.
service ssh start
/usr/sbin/apache2ctl -D FOREGROUND
