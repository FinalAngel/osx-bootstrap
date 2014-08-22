#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# installing compass
`which -s compass`
if [[ $? != 0 ]]; then
    echo ''
    echo '##### Installing Gem Compass...'
	sudo gem install sass
	sudo gem install compass
	sudo gem install bootstrap-sass
fi
