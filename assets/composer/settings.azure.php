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
 'isolation_level' => 'READ COMMITTED',
 'pdo' => [
   \PDO::MYSQL_ATTR_SSL_CA   => '/etc/ssl/certs/DigiCert_Global_Root_CA.pem',
   \PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => FALSE,
 ],
];

/**
 * Private files path.
 */
$settings['file_private_path'] = '/var/www/share/private';

/**
 * Reverse proxy configuration.
 */
$settings['reverse_proxy'] = TRUE;
$proxy_ip = getenv('REMOTE_ADDR', true) ?? getenv('REMOTE_ADDR');
$settings['reverse_proxy_addresses'] = [$proxy_ip];

/**
 * Stage file proxy config.
 */
$config['stage_file_proxy.settings']['origin'] = getenv('AZURE_CANONICAL_URL');

/**
 * Config split.
 */
$environment = getenv('AZURE_ENVIRONMENT') ?? 'dev';
if ($environment === 'production') {
  $config['config_split.config_split.prod']['status'] = TRUE;
}
elseif ($environment === 'dev') {
  $config['config_split.config_split.dev']['status'] = TRUE;
}
elseif ($environment === 'uat') {
  $config['config_split.config_split.uat']['status'] = TRUE;
}
