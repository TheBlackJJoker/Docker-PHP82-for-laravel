FROM phpdockerio/php:8.4-fpm
WORKDIR "/application"

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        git \
        php8.4-bcmath \
        php8.4-gd \
        php8.4-mysql \
        php8.4-xdebug; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
