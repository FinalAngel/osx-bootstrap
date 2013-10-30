#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo 'OSX Bootstrap Ruby'
echo '------------------'
echo ''

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install ruby
ruby=`brew list | grep ruby`
if [[ ! $ruby ]]; then
	# RVM installation
	curl -L https://get.rvm.io | bash -s stable --ruby
	source ~/.rvm/scripts/rvm

	# Ruby instlalation
	rvm install 1.9.3-head
	rvm use ruby-1.9.3-head

	# Rails installation
	gem install rails
fi