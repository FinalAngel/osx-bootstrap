#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install npm
npm=`brew list | grep node`
if [[ ! $npm ]]; then
	# node installation
	brew install node

	# npm installation
	curl https://npmjs.org/install.sh | sh

	# att path
	export NODE_PATH="/usr/local/lib/node"
	export PATH="/usr/local/share/npm/bin:$PATH"

	# install additional packages
	npm install -g bower
	npm install -g grunt-cli
	npm install -g gulp
fi