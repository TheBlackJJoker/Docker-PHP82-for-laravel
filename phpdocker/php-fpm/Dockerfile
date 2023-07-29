FROM phpdockerio/php:8.2-fpm
WORKDIR "/application"

ARG USER_NAME=host-user
ARG USER_ID=1000
ARG PHP_FPM_GROUP=www-data

RUN adduser \
        --disabled-password \
        --uid ${USER_ID} \
        ${USER_NAME} \
    && usermod \
        --append \
        --groups \
        ${PHP_FPM_GROUP} \
        ${USER_NAME}

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        git \
        php8.2-bcmath \
        php8.2-gd \
        php8.2-mysql \
        php8.2-redis \
        php8.2-xdebug; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
