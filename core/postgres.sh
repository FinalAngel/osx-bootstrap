#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# install postgres
postgres=`brew list | grep postgres`
if [[ ! $postgres ]]; then
    echo ''
    echo '##### Installing Formula Postgres...'
    
    PYTHON=/usr/local/bin/python brew install postgis

    # update system
    # http://blog.55minutes.com/2013/09/postgresql-93-brew-upgrade/
    sudo sysctl -w kern.sysv.shmall=65536
    sudo sysctl -w kern.sysv.shmmax=16777216
    # make sure settings stay after restart
    sudo cp -rf $source_dir/templates/sysctl.conf /etc

    # setup postgres
    initdb /usr/local/var/postgres -E utf8
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    createuser postgres -s

    # setup postgis
    createdb template_postgis
    createlang plpgsql template_postgis
    psql -d template_postgis -f /usr/local/Cellar/postgis/*/share/postgis/postgis.sql -U postgres
    psql -d template_postgis -f /usr/local/Cellar/postgis/*/share/postgis/spatial_ref_sys.sql -U postgres
    
    # always load postgres
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

    # brew fixes
    brew unlink libxml2

    # install required gem
    sudo gem install pg
fi
