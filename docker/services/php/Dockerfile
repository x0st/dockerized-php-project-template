FROM php:7.4-rc-fpm-alpine

# common dependencies
# RUN apk add autoconf \
#    g++=8.3.0-r0 \
#    gcc=8.3.0-r0 \
#    make=4.2.1-r2 \
#    imagemagick-dev \
#    imagemagick \
#    jpeg-dev \
#    libpng-dev \
#    freetype-dev

# installing imagick
# RUN pecl install imagick
# RUN docker-php-ext-enable imagick

# installing gd
# RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include --with-png-dir=/usr/include --with-freetype-dir=/usr/include
# RUN docker-php-ext-install gd

# installing pdo mysql
RUN docker-php-ext-install pdo pdo_mysql

CMD ["php-fpm"]
