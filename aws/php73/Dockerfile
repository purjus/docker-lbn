FROM php:7.3.23-fpm-stretch
LABEL maintainer="technique+docker@purjus.fr"

ARG APCU_VERSION=5.1.17
ARG NODE_VERSION=14


# PHP extensions
RUN buildDeps=" \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxslt-dev \
    " \
    && apt-get update -qq && apt-get install -qq --no-install-recommends \
        $buildDeps \
        libicu57 \
        zlib1g \
        libzip4 \
        libxslt1.1 \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        intl \
        pdo_mysql \
        zip \
        gd \
        xsl \
    && pecl install \
        apcu-${APCU_VERSION} \
    && docker-php-ext-enable --ini-name 20-apcu.ini apcu \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && apt-get purge --yes --auto-remove $buildDeps

# PHP imagick
RUN apt-get update -qq && apt-get install -qq --no-install-recommends libmagickwand-dev && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) exif

# PHP memcached
RUN apt-get update -qq && apt-get install -qq --no-install-recommends libmemcached-dev && rm -rf /var/lib/apt/lists/* \
    && pecl install memcached-3.1.5 \
    && docker-php-ext-enable memcached

# System
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
         git unzip wget ssh pngquant mysql-client gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Compile & install mozjpeg
COPY install-mozjpeg.sh /usr/local/bin/docker-app-install-mozjpeg
RUN chmod +x /usr/local/bin/docker-app-install-mozjpeg
RUN docker-app-install-mozjpeg

# Composer
# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY lbn_aws.ini /usr/local/etc/php/conf.d/lbn_aws.ini

# Node
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -qq --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -qq --no-install-recommends yarn \
    && rm -rf /var/lib/apt/lists/*

CMD ["php-fpm"]
