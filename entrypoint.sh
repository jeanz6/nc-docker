#!/bin/bash
php-fpm7.0 -D 
chmod 777 /var/run/php/php7.0-fpm.sock
nginx
ADMIN_MAIL=woelpert@physi.uni-heidelberg.de 
DOMAIN=edv-cloud.physi.uni-heidelberg.de
while true; do
PROCS=`ps aux`

echo $PROCS | grep --silent php-fpm
if [ ! $? = 0 ]; then
echo "php-fpm ist gestorben"
exit 1
fi

echo $PROCS | grep --silent nginx
if [ ! $? = 0 ]; then
echo "nginx ist gestorben"
exit 1
fi
sleep 1s
certbot   --nginx  --non-interactive --agree-tos  --redirect --hsts --staple-ocsp --email $ADMIN_MAIL -d $DOMAIN
done


