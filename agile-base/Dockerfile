FROM php:7.0-fpm
LABEL maintainer="technique+docker@purjus.fr"

ARG APCU_VERSION=5.1.8

# PHP extensions
RUN buildDeps=" \
        libicu-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
    " \
    && apt-get update -qq && apt-get install -y --force-yes -q --no-install-recommends \
        $buildDeps \
        libicu52 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        intl \
        mbstring \
        pdo_mysql \
        zip \
        gd \
    && pecl install \
        apcu-${APCU_VERSION} \
    && docker-php-ext-enable --ini-name 20-apcu.ini apcu \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && apt-get purge -y --auto-remove $buildDeps

# PHP imagick
RUN apt-get update -qq && apt-get install -y --force-yes -q --no-install-recommends libmagickwand-dev && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) exif

# PHP memcached
RUN apt-get update -qq && apt-get install -y --force-yes -q --no-install-recommends libmemcached-dev && rm -rf /var/lib/apt/lists/* \
    && pecl install memcached-3.0.3 \
    && docker-php-ext-enable memcached

# System
RUN apt-get update -qq && apt-get install -y --force-yes -q --no-install-recommends \
         git unzip wget ssh pngquant mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Compile & install wget
COPY install-wget.sh /usr/local/bin/docker-app-install-wget
RUN chmod +x /usr/local/bin/docker-app-install-wget
RUN docker-app-install-wget

# Compile & install mozjpeg
COPY install-mozjpeg.sh /usr/local/bin/docker-app-install-mozjpeg
RUN chmod +x /usr/local/bin/docker-app-install-mozjpeg
RUN docker-app-install-mozjpeg

# Composer
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY php.ini /usr/local/etc/php/php.ini

RUN composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --optimize-autoloader --classmap-authoritative \
    && composer clear-cache

## Node
#RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
#    && apt-get install -y --force-yes -q --no-install-recommends nodejs \
#    && rm -rf /var/lib/apt/lists/*
#
## Yarn
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#    && apt-get update -qq && apt-get install -y --force-yes -q --no-install-recommends yarn \
#    && rm -rf /var/lib/apt/lists/*


CMD ["php-fpm"]
