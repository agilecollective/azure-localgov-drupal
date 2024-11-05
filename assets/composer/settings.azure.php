<?php

/**
 * Azure database credentials.
 */
$databases['default']['default'] = [
  'database' => getenv('AZURE_MYSQL_DBNAME'),
  'username' => getenv('AZURE_MYSQL_USERNAME'),
  'password' => getenv('AZURE_MYSQL_PASSWORD'),
  'host' => getenv('AZURE_MYSQL_HOST'),
  'port' => getenv('AZURE_MYSQL_PORT'),
  'driver' => 'mysql',
  'prefix' => '',
  'collation' => 'utf8mb4_general_ci',
  'pdo' => [
    \PDO::MYSQL_ATTR_SSL_CA   => '/etc/ssl/certs/DigiCert_Global_Root_CA.pem',
    \PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => FALSE,
  ],
];

$settings['file_private_path'] = '/var/www/shared/private_files';
