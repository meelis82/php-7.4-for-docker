FROM php:7.4-fpm-buster
RUN mkdir -p /apache/data
WORKDIR /apache/data

ENV TERM xterm-256color

RUN apt-get update && apt-get install -y \
        advancecomp \
        gnupg2 \
	bash \
        htop \
        imagemagick \
        libapache2-mod-auth-openidc \
        libc-client-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libjpeg-progs \
        libkrb5-dev \
        libldap2-dev \
        libmagickwand-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libssl-dev \
        libwebp-dev \
        libwebp6 \
        libxml2-dev \
        libzip-dev \
        memcached \
        libonig-dev \
        default-mysql-client \
        trimage \
        unzip \
        vim \
        webp \
        wget \
        zlib1g-dev \
    && pecl install apcu igbinary redis xdebug \
    && docker-php-ext-enable apcu igbinary redis xdebug \
    && docker-php-ext-configure \
        gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp \
    && docker-php-ext-install -j$(nproc) \
        curl \
        dom \
        ftp \
        gd \
        iconv \
        json \
        ldap \
        mbstring \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        phar \
        simplexml \
        soap \
        xml \
        xmlrpc \
        zip

RUN curl -sL https://getcomposer.org/installer | php -- --install-dir /usr/bin --filename composer && composer global require drush/drush:8.* && ln -s /root/.composer/vendor/drush/drush/drush /usr/local/bin/drush

RUN groupadd -g 1000 container && userdel www-data && useradd -d /apache/data -o -s /bin/bash -u 1000 -g 1000 container

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY profile_colors.sh /etc/profile.d/profile_colors.sh

RUN chmod +x /etc/profile.d/profile_colors.sh
