# 1 Set master image
FROM php:7.4-fpm-alpine3.15

# 2 Set working directory
WORKDIR /var/www

# 3 Install Additional dependencies
# php7-mcrypt \ removed from security reason [2022-11-03]
RUN apk update && apk add --no-cache \
build-base shadow vim curl \
mc \
php7 \
php7-dev \
php7-pear \
php7-fpm \
php7-common \
php7-pdo \
php7-pdo_mysql \
php7-mysqli \
php7-mbstring \
php7-xml \
php7-openssl \
php7-json \
php7-phar \
php7-zip \
php7-gd \
php7-dom \
php7-session \
php7-zlib \
libjpeg-turbo-dev \
libpng-dev \
libwebp-dev \
freetype-dev

# 4 Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql mysqli sockets
RUN docker-php-ext-enable pdo_mysql sockets
RUN docker-php-ext-configure gd --with-jpeg --with-freetype
RUN docker-php-ext-install gd

RUN apk add --no-cache \
      libzip-dev \
      zip \
    && docker-php-ext-install zip

# 5 Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# 6 Install PHP Extensions (igbinary & memcached)
RUN apk add --no-cache --update libmemcached-libs zlib
RUN set -xe && \
    cd /tmp/ && \
    apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS && \
    apk add --no-cache --update --virtual .memcached-deps zlib-dev libmemcached-dev cyrus-sasl-dev && \
# Install igbinary (memcached's deps)
    pecl install igbinary && \
# Install memcached
    ( \
        pecl install --nobuild memcached && \
        cd "$(pecl config-get temp_dir)/memcached" && \
        phpize && \
        ./configure --enable-memcached-igbinary && \
        make -j$(nproc) && \
        make install && \
        cd /tmp/ \
    ) && \
# Enable PHP extensions
    docker-php-ext-enable igbinary memcached && \
    rm -rf /tmp/* && \
    apk del .memcached-deps .phpize-deps


# 7 Install MongoDB
RUN \
    apk add --no-cache --virtual .mongodb-ext-build-deps openssl-dev pcre-dev
    
RUN \
    pecl install mongodb && \
    apk del .mongodb-ext-build-deps && \
    pecl clear-cache && \
    docker-php-ext-enable mongodb && \
    docker-php-source delete

# install headless chrome
RUN apk add --no-cache chromium --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main

# install FFmpeg
RUN apk add --no-cache ffmpeg

# 8 Remove Cache
RUN rm -rf /var/cache/apk/*

# 9 Add UID '1000' to www-data
# RUN usermod -u 1000 www-data

# 10 Copy existing application directory permissions
# COPY --chown=www-data:www-data . /var/www/html

# 11 Change current user to www
# USER www-data

# 12 Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
