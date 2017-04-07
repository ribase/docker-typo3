# Serveur apache
FROM debian:latest

MAINTAINER Sebastian Thadewald <sebastian@wondrous.ch>

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-fastcgi

RUN rm /etc/apache2/sites-enabled/*

ENV VIRTUALHOST www.typo3.local

ADD conf-available /etc/apache2/conf-available
ADD sites-available /etc/apache2/sites-available

EXPOSE 80

ADD apache.sh /usr/bin/apache.sh
RUN chmod +x /usr/bin/apache.sh
ENTRYPOINT apache.sh

VOLUME /var/www/web

WORKDIR /var/www/web