FROM debian:jessie
MAINTAINER  TuyenNT  <nttuyen266@gmail.com>

RUN apt-get update \
	&& apt-get -y --force-yes install  \
		sudo	\
		vim  	\
		telnet 	\
		zlibc	\
		mysql-client \
		apache2 \
		php5 libapache2-mod-php5 php5-mcrypt php5-cgi php5-cli php5-common php5-curl php5-dev php5-gd php5-mysql php5-xdebug php5-memcached \
	&& a2enmod rewrite

RUN echo 'xdebug.remote_autostart=0' >> /etc/php5/mods-available/xdebug.ini \
	&& echo 'xdebug.remote_enable=1' >> /etc/php5/mods-available/xdebug.ini \
	&& echo 'xdebug.remote_connect_back=1' >> /etc/php5/mods-available/xdebug.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');"


COPY entrypoint.sh		/usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh \
	&& mkdir /installer.d \
	&& mkdir /startup.d

WORKDIR /var/www/html
VOLUME ["/var/www/html", "/installer.d", "/startup.d"]
EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2"]
