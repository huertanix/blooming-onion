#!/usr/bin/env bash
# Blooming Onion (c) David Huerta. Distributed under the GPL v3 license. See LICENSE.txt for deets.

echo 'Removing any installed mail servers because they will hurt you.'
echo 'Type "y" and hit enter to remove when asked.'
apt-get -y remove --purge exim postfix sendmail

echo 'Applying software updates...'
#echo 'Type "y" and hit enter to install when asked.'
apt-get update
apt-get -y --force-confold upgrade

echo 'Installing Tor from official Tor software repository...'
#echo 'Type "y" and hit enter to install Tor when asked.'
add-apt-repository http://deb.torproject.org/torproject.org
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
apt-get update
apt-get -y --force-confold install tor deb.torproject.org-keyring

#echo 'Configuring automatic security upgrades...'
#apt-get -y install unattended-upgrades
#cp blooming-onion/config/apt/20auto-upgrades /etc/apt/apt.conf.d/.

# Copy original config in case it needs to be restored later
cp blooming-onion/config/tor/torrc ./tor/torrc.orig

echo 'Setting up Tor onion service and waiting 5 seconds for .onion address creation...'
cp blooming-onion/config/tor/torrc /etc/tor/.
service tor reload
sleep 5s

ONION_ADDRESS=`cat /var/lib/tor/hidden_service/hostname`

if [ -n "$ONION_ADDRESS" ]; then
    # Copy for future restore
    cp /etc/nginx/sites-available/ghost blooming-onion/config/nginx/ghost.orig
    echo 'Setting up the web server NGINX to use Tor onion service...'
    cp blooming-onion/config/nginx/ghost /etc/nginx/sites-available/.
    sed -i 's/ONION_PLACEHOLDER/'$ONION_ADDRESS'/g' /etc/nginx/sites-available/ghost
    # Copy for future restore
    cp /var/www/ghost/config.production.json blooming-onion/config/ghost/config.production.json.orig
    echo 'Updating Ghost config to use .onion address...'
    #cp blooming-onion/config/ghost/config.production.json /var/www/ghost/.
    sed -i 's/\"url\": \"http:\/\/.*\"/\"url\": \"http:\/\/'$ONION_ADDRESS'\"/g' /var/www/ghost/config.production.json

    echo 'Restarting NGINX...'
    service nginx reload

    echo 'Congrats! You now have your very own Tor onion service.'
    echo 'Enter this address into the Tor browser: '$ONION_ADDRESS
else
    echo 'Could not get a .onion address. :( Try running this script one more time?'
fi
