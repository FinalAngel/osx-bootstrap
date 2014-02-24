#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo ''
echo 'OSX Bootstrap 1.3.0'
echo '-------------------'
echo ''

# define variables
declare source_dir=~/.osx-bootstrap
declare source_file=$source_dir/.osx-bootstrap
declare source_file_tmp=$source_dir/.osx-bootstrap-tmp
declare password

# we need to download the repo for the absolute paths
if [[ ! -d ~/.osx-bootstrap ]]; then
    echo '##### Downloading Bootstrap...'
	# autoupdate bootstrap file
	git clone https://github.com/divio/osx-bootstrap.git $source_dir
	# hide folder
	chflags hidden $source_dir
else
	# update repo
    echo '##### Running Bootstrap Updates...'
	cd $source_dir
	git pull origin master
fi

# define helpers
source $source_dir/core/helpers.sh
     
# create bootstrap tmp
[[ ! -f $source_file ]] && cp -rf $source_dir/install.sh $source_file_tmp

# include system with param $1
source $source_dir/core/system.sh $1
# install brew
source $source_dir/core/brew.sh
# install python
source $source_dir/core/python.sh
# install mysql
source $source_dir/core/mysql.sh
# install postgres
source $source_dir/core/postgres.sh
# install zsh
source $source_dir/core/zsh.sh
# install defaults
source $source_dir/core/defaults.sh
# install github
source $source_dir/core/github.sh
# place your extras here

# create bootstrap file
[[ ! -f $source_file ]] && mv $source_file_tmp $source_file && chmod +x $source_file

# done
echo ''
cowsay 'Bootstrapp Ready!'
echo ''

# call helper function from libs/system.sh
require_reboot
