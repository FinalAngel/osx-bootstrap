#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# require sudo password
require_sudo

# installing compass
`which -s compass`
if [[ $? != 0 ]]; then
    echo ''
    echo '##### Installing Gem Compass...'
	sudo gem install sass -v '>=3.3.0alpha' --pre
	sudo gem install compass -v '>=1.0.0alpha' --pre
	sudo gem install bootstrap-sass
fi
