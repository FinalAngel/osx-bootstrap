#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo 'OSX Bootstrap NPM'
echo '------------------'
echo ''

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install npm
`brew list | grep node`
[[ $1 != 0 ]]; then
	# node installation
	brew install node

	# npm installation
	curl https://npmjs.org/install.sh | sh

	# att path
	export NODE_PATH="/usr/local/lib/node"
	# path for
	# PATH="/usr/local/share/npm/bin:$PATH"
fi