#!/bin/bash

echo 'Removing any installed mail servers because they will hurt you.'
apt-get remove --purge exim
apt-get remove --purge postfix
apt-get remove --purge sendmail

echo 'Applying software updates... Type "y" and hit enter to install when asked.'
apt-get update
apt-get upgrade

