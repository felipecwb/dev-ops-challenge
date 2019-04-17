FROM alpine:3.9

ENV USER  todo
ENV GROUP todo
ENV WORKDIR /home/todo
ENV PHPFPM_SOCK /tmp/php-fpm7.sock

# USER
RUN addgroup -g 1000 $GROUP \
    && adduser -S -u 1000 -G $GROUP $USER

# installs
RUN apk add --update --no-cache \
    curl \
    sqlite \
    runit \
    nginx \
    php7 \
    php7-bz2 \
    php7-calendar \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_sqlite \
    php7-pdo_mysql \
    php7-pcntl \
    php7-phar \
    php7-posix \
    php7-session \
    php7-simplexml \
    php7-sockets \
    php7-sodium \
    php7-tokenizer \
    php7-zip

# RUNIT Services nginx & php-fpm7
RUN mkdir -p /etc/service/nginx \
    && { \
        echo '#!/bin/sh'; \
        echo 'exec /usr/sbin/nginx || exit 1'; \
    } | tee /etc/service/nginx/run \
    && chmod a+x /etc/service/nginx/run \
    \
    && mkdir -p /etc/service/php-fpm7 \
    && { \
        echo '#!/bin/sh'; \
        echo 'exec /usr/sbin/php-fpm7 --nodaemonize --force-stderr || exit 1'; \
    } | tee /etc/service/php-fpm7/run \
    && chmod a+x /etc/service/php-fpm7/run

# PHP CONFIG
RUN { \
        echo '[global]'; \
        echo 'error_log = /proc/self/fd/2'; \
        echo 'include=/etc/php7/php-fpm.d/*.conf'; \
    } | tee /etc/php7/php-fpm.conf \
    && { \
        echo '[www]'; \
        echo "user   = $USER"; \
        echo "group  = $GROUP"; \
        echo "listen = $PHPFPM_SOCK"; \
        echo "listen.owner = $USER"; \
        echo "listen.group = $GROUP"; \
        echo 'listen.mode  = 0666'; \
        echo 'pm = dynamic'; \
        echo 'pm.start_servers = 1'; \
        echo 'pm.max_children  = 5'; \
        echo 'pm.min_spare_servers = 1'; \
        echo 'pm.max_spare_servers = 3'; \
        #echo 'access.log = /dev/stderr'; \
        echo 'access.log = /dev/null'; \
        echo 'catch_workers_output = yes'; \
        echo 'clear_env = no'; \
        echo 'php_admin_flag[log_errors] = on'; \
        echo 'php_admin_value[error_log] = /proc/self/fd/2'; \
    } | tee /etc/php7/php-fpm.d/www.conf

# NGINX CONFIG
RUN sed -i "s|user nginx|user $USER $GROUP|" /etc/nginx/nginx.conf \
    && sed -i "s|/var/log/nginx/access.log|/dev/stdout|" /etc/nginx/nginx.conf \
    && sed -i "s|/var/log/nginx/error.log|/dev/stderr|"  /etc/nginx/nginx.conf \
    && { \
        echo 'pid /tmp/nginx.pid;'; \
        echo 'daemon off;'; \
    } | tee -a /etc/nginx/nginx.conf \
    && { \
        echo 'server {'; \
        echo '  listen 8080;'; \
        echo '  listen [::]:8080;'; \
        echo "  root ${WORKDIR}/public;"; \
        echo '  index index.html index.php;'; \
        echo '  access_log /dev/stdout;'; \
        echo '  error_log  /dev/stderr;'; \
        \
        echo '  location / {'; \
        echo '    try_files $uri /index.php$is_args$args;'; \
        echo '  }'; \
        \
        echo '  location ~ \.php$ {'; \
        echo '    fastcgi_split_path_info ^(.+\.php)(/.+)$;'; \
        echo "    fastcgi_pass unix:${PHPFPM_SOCK};"; \
        echo '    fastcgi_index index.php;'; \
        echo '    fastcgi_param HTTP_PROXY "";'; \
        echo '    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;'; \
        echo '    include fastcgi_params;'; \
        echo '  }'; \
        echo '}'; \
    } | tee /etc/nginx/conf.d/default.conf

# composer install
RUN curl https://getcomposer.org/composer.phar -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

USER ${USER}
WORKDIR $WORKDIR

COPY --chown=todo:todo composer.json composer.lock $WORKDIR/
RUN composer install --prefer-dist --optimize-autoloader --no-dev --no-interaction

COPY --chown=todo:todo . $WORKDIR/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl --fail http://localhost:8080/healthcheck || exit 1

# requires root
USER root
CMD ["runsvdir", "/etc/service"]
