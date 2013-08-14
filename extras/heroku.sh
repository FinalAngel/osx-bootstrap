#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo "OSX Bootstrap Heroku"
echo "--------------------"
echo ""

# define helpers
source_dir='~/.osx-bootstrap'
source $source_dir/core/helpers.sh

# require sudo password
require_sudo

`which -s heroku`
if [[ $? != 0 ]]; then
    # Install Heroku toolbelt
    echo "##### Installing heroku toolbelt"
    curl -O http://assets.heroku.com/heroku-toolbelt/heroku-toolbelt.pkg
    sudo installer -store -pkg /tmp/heroku-toolbelt.pkg
    echo 'Note: open https://api.heroku.com/login'
    echo 'Note: https://api.heroku.com/signup'
    read -p "Press return when done with Heroku installation"

	echo '##### Heroku login test'
	heroku login
	heroku keys | grep 'No keys' && heroku keys:add
else
    heroku update
fi