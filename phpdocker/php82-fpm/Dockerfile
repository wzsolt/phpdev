FROM php:8.2.11-fpm-alpine3.17

# Composer - https://getcomposer.org/download/
ARG COMPOSER_VERSION="2.6.4"
ARG COMPOSER_SUM="5a39f3e2ce5ba391ee3fecb227faf21390f5b7ed5c56f14cab9e1c3048bcf8b8"

# Install dependencies
RUN set -eux \
    && apk add --no-cache \
        c-client \
        ca-certificates \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        imagemagick \
        imap \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libpng \
        libpq \
        librdkafka \
        libssh2 \
        libstdc++ \
        libtool \
        libxpm \
        libxslt \
        libzip \
        make \
        rabbitmq-c \
        tidyhtml \
        tzdata \
        unixodbc \
        vips \
        yaml

#############################################
### Install and enable PHP extensions
#############################################

# Development dependencies
RUN set -eux \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        bzip2-dev \
        cmake \
        curl-dev \
        freetds-dev \
        freetype-dev \
        g++ \
        gcc \
        gettext-dev \
        git \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        imap-dev \
        krb5-dev \
        libc-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        librdkafka-dev \
        libssh2-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libzip-dev \
        openssl-dev \
        pcre-dev \
        pkgconf \
        postgresql-dev \
        tidyhtml-dev \
        unixodbc-dev \
        vips-dev \
        yaml-dev \
        zlib-dev \
\
# Enable ffi if it exists
    && set -eux \
    && if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
        echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
    fi \
\
################################
# Install PHP extensions
################################
\
# Install gd
    && ln -s /usr/lib/$(apk --print-arch)-linux-gnu/libXpm.* /usr/lib/ \
    && docker-php-ext-configure gd \
        --enable-gd \
        --with-webp \
        --with-jpeg \
        --with-xpm \
        --with-freetype \
        --enable-gd-jis-conv \
    && docker-php-ext-install -j$(nproc) gd \
    && true \
\
# Install apcu
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && true \
\
# Install gettext
    && docker-php-ext-install -j$(nproc) gettext \
    && true \
\
# Install gmp
    && docker-php-ext-install -j$(nproc) gmp \
    && true \
\
# Install bcmath
    && docker-php-ext-install -j$(nproc) bcmath \
    && true \
\
# Install bz2
    && docker-php-ext-install -j$(nproc) bz2 \
    && true \
\
# Install exif
    && docker-php-ext-install -j$(nproc) exif \
    && true \
\
# Install imap
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl --with-imap \
    && docker-php-ext-install -j$(nproc) imap \
    && true \
\
# Install imagick
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && true \
\
# Install intl
    && docker-php-ext-install -j$(nproc) intl \
    && true \
\
# Install memcache
    && pecl install memcache \
    && docker-php-ext-enable memcache \
    && true \
\
# Install mongodb
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && true \
\
# Install mysqli
    && docker-php-ext-install -j$(nproc) mysqli \
    && true \
\
# Install oauth
    && pecl install oauth \
    && docker-php-ext-enable oauth \
    && true \
\
# Install opcache
    && docker-php-ext-install -j$(nproc) opcache \
    && true \
\
# Install pdo_mysql
    && docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && true \
\
# Install pdo_dblib
    && docker-php-ext-install -j$(nproc) pdo_dblib \
    && true \
\
# Install pcntl
    && docker-php-ext-install -j$(nproc) pcntl \
    && true \
\
# Install pdo_pgsql
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && true \
\
# Install pgsql
    && docker-php-ext-install -j$(nproc) pgsql \
    && true \
\
# ONLY 64-bit targets
    && if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "aarch64" ]; then \
    # Install sqlsrv
        pecl install sqlsrv; \
        docker-php-ext-enable sqlsrv; \
        true; \
    # Install pdo_sqlsrv
        pecl install pdo_sqlsrv; \
        docker-php-ext-enable pdo_sqlsrv; \
        true; \
    fi \
\
# Install psr
    && pecl install psr \
    && docker-php-ext-enable psr \
    && true \
\
# Install ssh2
    && pecl install ssh2-1.3.1 \
    && docker-php-ext-enable ssh2 \
    && true \
\
# Install sockets, sysvmsg, sysvsem, sysvshm
    && CFLAGS="${CFLAGS:=} -D_GNU_SOURCE" docker-php-ext-install -j$(nproc) \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
    && docker-php-source extract \
    && true \
\
# Install tidy
    && docker-php-ext-install -j$(nproc) tidy \
    && true \
\
# Install xsl
    && docker-php-ext-install -j$(nproc) xsl \
    && true \
\
# Install xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && true \
\
# Install yaml
    && pecl install yaml \
    && docker-php-ext-enable yaml \
    && true \
\
# Install vips
    && pecl install vips \
    && docker-php-ext-enable vips \
    && true \
\
# Install zip
    && docker-php-ext-configure zip --with-zip \
    && docker-php-ext-install -j$(nproc) zip \
    && true \
\
# Clean up build packages
    && docker-php-source delete \
    && apk del .build-deps \
    && true

RUN set -eux \
# Fix php.ini settings for enabled extensions
    && chmod +x "$(php -r 'echo ini_get("extension_dir");')"/* \
# Shrink binaries
    && (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
    && true

# Install Composer
RUN set -eux \
    && curl -LO "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
    && echo "${COMPOSER_SUM}  composer.phar" | sha256sum -c - \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer --version \
    && true

# 5 Install PHP Extensions (igbinary & memcached)
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

# install headless chrome
RUN apk add --no-cache chromium --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main

# install FFmpeg
RUN apk add --no-cache ffmpeg

# 6 Remove Cache
RUN rm -rf /tmp/* /var/cache/apk/* \
  && echo "=============================================" \
  && php -m

# 7 Add UID '1000' to www-data
# RUN usermod -u 1000 www-data

# 8 Copy existing application directory permissions
# COPY --chown=www-data:www-data . /var/www

# 9 Change current user to www
# USER www-data
