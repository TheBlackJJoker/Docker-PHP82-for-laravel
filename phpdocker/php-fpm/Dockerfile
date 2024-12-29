FROM phpdockerio/php:8.4-fpm
WORKDIR "/application"

ARG USER_NAME=host-user
ARG USER_ID=1000
ARG PHP_FPM_GROUP=www-data

RUN if getent passwd ${USER_ID} > /dev/null; then \
        EXISTING_USER=$(getent passwd ${USER_ID} | cut -d: -f1); \
        echo "UID ${USER_ID} already exists, using user ${EXISTING_USER}."; \
        USER_NAME=${EXISTING_USER}; \
    else \
        echo "UID ${USER_ID} not found, creating new user ${USER_NAME}."; \
        adduser --disabled-password --uid ${USER_ID} ${USER_NAME}; \
    fi && \
    if getent group ${USER_ID} > /dev/null; then \
        EXISTING_GROUP=$(getent group ${USER_ID} | cut -d: -f1); \
        echo "GID ${USER_ID} already exists for group ${EXISTING_GROUP}, skipping groupmod."; \
    else \
        echo "GID ${USER_ID} not found, modifying group ${PHP_FPM_GROUP}."; \
        groupmod --gid ${USER_ID} ${PHP_FPM_GROUP}; \
    fi && \
    echo "Adding user ${USER_NAME} to group ${PHP_FPM_GROUP}."; \
    usermod --append --groups ${PHP_FPM_GROUP} ${USER_NAME}

RUN apt-get update && apt-get -y --no-install-recommends install \
    git \
    unzip \
    libcurl4-openssl-dev \
    libonig-dev \
    libxml2-dev \
    libpcre3-dev \
    php8.4-bcmath \
    php8.4-gd \
    php8.4-pdo_mysql \
    php8.4-mysql \
    php8.4-intl \
    php8.4-xdg \
    php8.4-xdebug \
    php8.4-ctype \
    php8.4-curl \
    php8.4-dom \
    php8.4-fileinfo \
    php8.4-filter \
    php8.4-hash \
    php8.4-mbstring \
    php8.4-openssl \
    php8.4-pcre \
    php8.4-session \
    php8.4-tokenizer \
    php8.4-xml; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*



COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
