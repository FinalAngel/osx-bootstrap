#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo "OSX Bootstrap PHP"
echo "-----------------"
echo ""

# define helpers
$source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source $source_dir/core/helpers.sh

# install php
php=`brew list | grep php`
if [[ ! $php ]]; then
    echo '##### Installing Formula PHP...'
    
    # we need to get php from another source
    brew tap josegonzalez/php
    brew tap homebrew/dupes
    brew install php54 --without-apache --with-fpm --with-imap --with-debug --with-mysql
    brew install unixodbc

    # setup php
    ln -sfv /usr/local/Cellar/php54/5.4.16/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist

    # setup nginx
    cd /usr/local/etc/nginx/
    cp -rf $source_dir/templates/nginx.conf /usr/local/etc/nginx
    mkdir sites-enabled

    # create dynamic conf file for mapping mysite.dev/:8080 to folder in ~/Sites
    # reference: https://gist.github.com/tmaiaroto/3307058
    cp -rf $source_dir/templates/dev.conf /usr/local/etc/nginx/sites-enabled

    # reload nginx
    nginx -s reload

    # copy php ini file
    cp -rf $source_dir/templates/php.ini /usr/local/etc/php/5.4
fi