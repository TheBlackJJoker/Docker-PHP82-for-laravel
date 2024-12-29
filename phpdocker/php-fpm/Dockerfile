FROM phpdockerio/php:8.4-fpm
WORKDIR "/application"

ARG USER_NAME=host-user
ARG USER_ID=1000
ARG PHP_FPM_GROUP=www-data

RUN if getent passwd ${USER_ID} > /dev/null; then \
        EXISTING_USER=$(getent passwd ${USER_ID} | cut -d: -f1); \
        usermod --uid ${USER_ID} ${EXISTING_USER} && \
        groupmod --gid ${USER_ID} ${PHP_FPM_GROUP}; \
    else \
        adduser \
            --disabled-password \
            --uid ${USER_ID} \
            ${USER_NAME} && \
        usermod \
            --append \
            --groups \
            ${PHP_FPM_GROUP} \
            ${USER_NAME}; \
    fi

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
