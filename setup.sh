#!/bin/bash

echo 'Removing any installed mail servers because they will hurt you.'
echo 'Type "y" and hit enter to remove when asked.'
apt-get remove --purge exim postfix sendmail

echo 'Applying software updates...'
echo 'Type "y" and hit enter to install when asked.'
apt-get update
apt-get upgrade

echo 'Installing Tor from official Tor software repository...'
echo 'Type "y" and hit enter to install when asked.'
add-apt-repository http://deb.torproject.org/torproject.org
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
apt-get update
apt-get install tor deb.torproject.org-keyring

echo 'Setting up Tor onion service...'
mv /etc/tor/torrc /etc/tor/torrc.orig
cp config/tor/torrc /etc/tor/.
service tor reload

ONION_ADDRESS=`cat /var/lib/tor/hidden_service/hostname`

echo 'Setting up the web server NGINX to use Tor onion service...'
mv /etc/nginx/sites-available/ghost /etc/nginx/sites-available/ghost.orig
cp config/nginx/ghost /etc/nginx/sites-available/.
sed -i bak -e s/ONION_PLACEHOLDER/$ONION_ADDRESS/g /etc/nginx/sites-available/ghost

echo 'Updating Ghost config to use .onion address...'
mv /var/www/ghost/config.js /var/www/ghost/config.js.orig
cp config/ghost/config.js /var/www/ghost/.
sed -i bak -e s/ONION_PLACEHOLDER/$ONION_ADDRESS/g /var/www/ghost/config.js

echo 'Restarting NGINX...'
service nginx reload

echo 'Congrats! You now have your very own Tor onion service.'
echo "Enter this address into the Tor browser: $ONION_ADDRESS"