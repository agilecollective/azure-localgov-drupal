##
# LocalGov Drupal Azure Web App container.
FROM php:8.3-apache

# Build arguments.
ARG ENVIRONMENT=production
ARG BUILD_ID

# Environment variables.
ENV AZURE_ENVIRONMENT=$ENVIRONMENT
ENV AZURE_BUILD_ID=$BUILD_ID

# Apache configuration.
ENV APACHE_DOCUMENT_ROOT=var/www/html/web
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_LOG_DIR=/var/log/apache2
ENV APACHE_PID_FILE=/var/run/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_RUN_USER=www-data
COPY azure-web-app/apache2/azure.conf /etc/apache2/conf-available/azure.conf
COPY azure-web-app/apache2/drupal.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod deflate expires headers rewrite && \
    a2enconf azure.conf

# PHP configuration.
RUN apt-get update && apt-get install -y --no-install-recommends \
      default-mysql-client \
      libcurl4-openssl-dev \
      libfreetype6-dev \
      libicu-dev \
      libjpeg62-turbo-dev \
      libonig-dev \
      libpng-dev \
      libxml2-dev \
      libwebp-dev \
      libzip-dev \
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install \
      bcmath \
      curl \
      gettext \
      intl \
      mbstring \
      mysqli \
      opcache \
      pdo \
      pdo_mysql \
      xml \
      zip  && \
    docker-php-source delete
COPY azure-web-app/php/drupal.ini /usr/local/etc/php/conf.d/drupal.ini
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Composer install.
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl \
      git \
      openssh-server \
      patch && \
    rm -rf /var/lib/apt/lists/* && \
    curl -o /usr/local/bin/composer https://getcomposer.org/composer-stable.phar && \
    chmod a+x /usr/local/bin/composer

# SSH install.
RUN apt-get update && apt-get install -y --no-install-recommends \
      dialog \
      openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    echo "root:Docker!" | chpasswd
COPY azure-web-app/ssh/sshd_config /etc/ssh/

# Cron install.
RUN apt-get update && apt-get install -y --no-install-recommends \
      cron && \
    rm -rf /var/lib/apt/lists/*
COPY azure-web-app/cron/drupal /etc/cron.d/drupal

# Setup Drupal site.
WORKDIR /var/www/html
COPY . /var/www/html
RUN composer install --no-interaction --prefer-dist --no-dev && \
    rm -fr ~/.composer

# Set startup script.
COPY azure-web-app/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 80 2222

ENTRYPOINT [ "/entrypoint.sh" ]
