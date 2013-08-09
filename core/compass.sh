#!/bin/bash

# define helpers
$source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source $source_dir/core/helpers.sh

# require sudo password
require_sudo

# installing compass
`which -s compass`
if [[ $? != 0 ]]; then
	sudo gem install compass
fi