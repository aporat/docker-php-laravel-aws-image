FROM php:8.4-fpm AS app

# mix
RUN apt-get update \
  && apt-get install -y build-essential supervisor zlib1g-dev default-mysql-client curl gnupg procps vim git unzip libzip-dev libpq-dev libmagickwand-dev

# extensions
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install opcache
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install bcmath

# intl
RUN apt-get install -y libicu-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl

# gd
RUN apt-get install -y libicu-dev libmagickwand-dev libmcrypt-dev libcurl3-dev jpegoptim libfreetype6-dev libjpeg62-turbo-dev libpng-dev && \
docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
docker-php-ext-install gd

# crontab
RUN apt-get install -y cron

# redis
RUN pecl install redis && docker-php-ext-enable redis

# pcov
RUN pecl install pcov && docker-php-ext-enable pcov

# nginx
RUN apt-get install -y nginx
RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx

RUN apt-get install -y supervisor

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# settings
COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi_fpm gzip_params /etc/nginx/
COPY php.ini $PHP_INI_DIR/

RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx

RUN addgroup --system --gid 1000 app-group
RUN adduser --system --ingroup app-group --uid 1000 app-user

# setup nginx user permissions
RUN chown -R app-user:app-group /var/lib/nginx /var/log/nginx
RUN chown -R app-user:app-group /usr/local/etc/php-fpm.d

# Entry point
COPY start-container.sh /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["/usr/local/bin/start-container"]