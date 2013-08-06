#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo "OSX Bootstrap PHP"
echo "-----------------"
echo ""

# install php
php=`brew list | grep php`
if [[ ! $php ]]; then
    echo '##### Installing Formula PHP...'
    
    # we need to get php from another source
    brew tap josegonzalez/php
    brew tap homebrew/dupes
    brew install php54 --without-apache --with-fpm --with-imap --with-debug --with-mysql

    # setup php
    ln -sfv /usr/local/Cellar/php54/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist

    # important paths
    # /usr/local/etc/nginx/nginx.conf
    # /usr/local/etc/php/5.4/php.ini
    cd /usr/local/etc/nginx/
    mv nginx.conf nginx.conf.old; sed '$d' nginx.conf.old > nginx.conf;
    echo '    include sites-enabled/*;' >> nginx.conf
    echo '}' >> nginx.conf
    nginx -s reload

    # now create a settings sites-enabled/mysite.dev.conf
    # http://mwholt.blogspot.ch/2012/09/installing-nginx-php-mysql-on-mac-os-x.html
fi