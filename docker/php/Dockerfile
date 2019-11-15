# Use oficial PHP with fpm.
FROM php:7.3.9-fpm

# Install extension dependencies
RUN apt-get update && apt-get -y install \
    git \
    zlib1g-dev \
    libzip-dev \
    unzip \
    mariadb-client

## Install PHP extensions
# bcmath sockets: php-amqplib/php-amqplib
RUN docker-php-ext-install \
    zip \
    bcmath \
    sockets \
    mysqli \
    pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Set working directory
WORKDIR /opt/app/

# Set permissions
RUN usermod -u 1000 www-data
RUN chown -R www-data: \
    /usr/local/etc/php/conf.d/ \
    /var/www

USER www-data
