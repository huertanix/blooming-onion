#!/usr/bin/env bash
# Blooming Onion (c) David Huerta, Stephanie Hyland. Distributed under the GPL v3 license. See LICENSE.txt for deets.

echo 'Restoring original configuration files!'

echo 'Restoring NGINX config...'
cp blooming-onion/config/nginx/ghost.orig /etc/nginx/sites-available/ghost
echo 'Restoring Ghost config...'
cp blooming-onion/config/ghost/config.js.orig /var/www/ghost/config.js
echo  'Restoring torrc...'
cp blooming-onion/config/tor/torrc.orig /etc/tor/torrc

echo 'Restarting services...'
service tor reload
service nginx reload

echo 'Confirming hidden service is gone...'
ONION_ADDRESS=`sudo cat /var/lib/tor/hidden_service/hostname`
if [ -n "$ONION_ADDRESS" ]
then
    echo 'ERROR:' $ONION_ADDRESS 'still exists! :('
else
    echo 'SUCCESS!'
fi
