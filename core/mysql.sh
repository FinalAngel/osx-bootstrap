#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# install mysql
mysql=`brew list | grep mysql`
if [[ ! $mysql ]]; then
    echo ''
    echo '##### Installing Formula MySQL...'
    brew install mysql

    # setup mysql
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi
