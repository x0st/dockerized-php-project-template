FROM php:7.4-rc-fpm-alpine
RUN docker-php-ext-install pdo pdo_mysql
RUN mkdir /var/log/adhoc-logs
COPY ./root /etc/crontabs/root
CMD ["crond", "-f"]
