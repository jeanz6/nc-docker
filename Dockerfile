#	Base Image
FROM debian:stretch


# installation of the needed packages 
RUN apt-get update && apt-get install -y nginx  \
	php-fpm wget unzip sed less vim \
     php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring \
     php7.0-intl php-imagick php7.0-xml php7.0-zip \
     libcurl4-openssl-dev \
     libfreetype6-dev \
     libicu-dev \
     libjpeg-dev \
     libldap2-dev \
     libmcrypt-dev \
     libmemcached-dev \
     libpng-dev \
     libpq-dev \
     libxml2-dev \
     openssl \
     certbot python-certbot-nginx 


# nextcloud version variable
ENV NEXTCLOUD_VERSION 15.0.7
ENV DOC_ROOT /var/www/nextcloud
ENV ADMIN_MAIL woelpert@physi.uni-heidelberg.de
ENV DOMAIN edv-cloud.physi.uni-heidelberg.de

#Working Directory in the Container
WORKDIR /var/www/

#nextcloud downloaden und unzipen dann directories erstellen 
RUN wget https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.zip \
     && unzip nextcloud-${NEXTCLOUD_VERSION}.zip \
     && mkdir /var/run/php  

# default logs to docker logs
RUN ln -sf /dev/stdout /var/log/php7.0-fpm.log && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    chown -R www-data:root ${DOC_ROOT} && \
    chmod -R a+rwx ${DOC_ROOT} && \
    mkdir /data/ && \
    chown -R www-data:root /data && \
    chmod -R a+rwx /data/
# certbot ssl cert    
#RUN certbot   --nginx  --non-interactive --agree-tos  --redirect --hsts --staple-ocsp --email ${ADMIN_MAIL} -d ${DOMAIN} 
 
#Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf 
#COPY cert.pem /etc/nginx/ssl-cert.pem
#COPY key.pem /etc/nginx/ssl-cert.key
#COPY --chown=www-data:www-data customconfig.php ${DOC_ROOT}/config/config.php
COPY entrypoint.sh /


#exposing port 80 and port 443 on the container
EXPOSE 80 443

# Maintainer of this Dockerfile
MAINTAINER Jens Wölpert <woelpert@physi.uni-heidelberg.de>

# executing the entrypoint script to start nginx php-fpm and a watchdog for those services
CMD [ "/bin/bash" , "/entrypoint.sh"]
