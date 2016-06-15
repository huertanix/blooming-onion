#!/usr/bin/env bash
# Blooming Onion (c) David Huerta, Stephanie Hyland. Distributed under the GPL v3 license. See LICENSE.txt for deets.

echo 'Restoring original configuration files!'

echo 'Restoring NGINX config...'
cp blooming-onion/config/nginx/ghost.orig /etc/nginx/sites-available/ghost
echo 'Restoring Ghost config...'
cp blooming-onion/config/ghost/config.js.orig /var/www/ghost/config.js
echo  'Restoring torrc...'
cp blooming-onion/config/tor/torrc.orig /etc/tor/torrc

# DANGERZONE
echo 'REMOVING hidden service ***CANNOT UNDO*** (requires confirmation)...'
rm -i /var/lib/tor/hidden_service/*
# END DANGERZONE

echo 'Restarting services...'
service tor reload
service nginx reload
