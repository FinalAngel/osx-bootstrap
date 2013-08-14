#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install postgres
postgres=`brew list | grep postgres`
if [[ ! $postgres ]]; then
    echo ''
    echo '##### Installing Formula Postgres...'
    
    PYTHON=/usr/local/bin/python brew install postgres

    # setup postgres
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    initdb /usr/local/var/postgres -E utf8

    # brew installs
    brew install postgis

    # brew fixes
    brew unlink libxml2
    
    # setup postgres
    createuser postgres -s

    # setup postgis
    createdb template_postgis
    createlang plpgsql template_postgis
fi