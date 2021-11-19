FROM php:7.2.34-fpm-stretch
LABEL maintainer="technique+docker@purjus.fr"

ARG APCU_VERSION=5.1.17


# PHP extensions
RUN buildDeps=" \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxslt-dev \
        libmagickwand-dev \
        libmemcached-dev \
    " \
    && apt-get update -qq && apt-get install -qq --no-install-recommends \
        $buildDeps \
        libicu57 \
        zlib1g \
        libzip4 \
        imagemagick \
        libxslt1.1 \
        libmemcached11 \
        libmemcachedutil2 \
        libmagickwand-6.q16-3 \
        git \
        unzip \
        wget \
        ssh \
        pngquant \
        mysql-client \
        gnupg2 \
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
        imagick \
        memcached-3.0.3 \
    && docker-php-ext-enable --ini-name 20-apcu.ini apcu \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) exif \
    && apt-get purge --yes --auto-remove $buildDeps


# Compile & install mozjpeg
COPY install-mozjpeg.sh /usr/local/bin/docker-app-install-mozjpeg
RUN chmod +x /usr/local/bin/docker-app-install-mozjpeg
RUN docker-app-install-mozjpeg

# Composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT -1
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

COPY lbn_aws.ini /usr/local/etc/php/conf.d/lbn_aws.ini

CMD ["php-fpm"]
