FROM php:7.1-apache
MAINTAINER  TuyenNT  <nttuyen266@gmail.com>

RUN apt-get update \
	&& apt-get -y --force-yes install  \
		apt-utils \
		sudo	\
		vim  	\
		telnet 	\
		zlibc	\
		wget	\
		mysql-client \
		git \
		sqlite3 libsqlite3-dev \
		bzip2 libbz2-dev \
		libxslt-dev	\
		libcurl3-dev

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libssl-dev \
        libicu-dev \
        libldb-dev libldap2-dev \
        libxml2-dev libpcre3-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \  
    && docker-php-ext-install opcache \
    && docker-php-ext-install -j$(nproc) mcrypt mysqli pdo_mysql bz2 exif gettext intl ldap sockets xsl zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && pecl install apcu \
    && docker-php-ext-enable apcu


RUN echo 'xdebug.remote_autostart=0' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
	&& echo 'xdebug.max_nesting_level=1000' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');"

RUN wget https://phar.phpunit.de/phpunit-6.4.phar \
	&& chmod +x phpunit-6.4.phar \
	&& mv phpunit-6.4.phar /usr/local/bin/phpunit

COPY entrypoint.sh		/usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh \
	&& mkdir /installer.d \
	&& mkdir /startup.d

RUN a2enmod rewrite deflate cache proxy ssl

RUN useradd -ms /bin/bash ubuntu
RUN chown -R ubuntu:ubuntu /var/www

WORKDIR /var/www/html
VOLUME ["/var/www/html", "/installer.d", "/startup.d"]
EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2"]
