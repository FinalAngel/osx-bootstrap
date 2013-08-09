#!/bin/bash

# define helpers
source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source <(curl -s $source_dir/core/helpers.sh)

# install mysql
mysql=`brew list | grep mysql`
if [[ ! $mysql ]]; then
    echo '##### Installing Formula MySQL...'
    brew install mysql
    brew install mysql-connector-c

    # link connector
    brew link --overwrite mysql-connector-c

    # setup mysql
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi