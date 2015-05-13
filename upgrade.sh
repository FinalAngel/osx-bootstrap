#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo ''
echo 'OSX Bootstrap Upgrade'
echo '---------------------'
echo ''

# Require sudo
sudo -v

# define variables
source_dir=~/.osx-bootstrap
source_file=$source_dir/.osx-bootstrap

# define helpers
source core/sudo.sh

# Request password
request_password

# copy file
cp -rf $source_dir/install.sh $source_file && chmod +x $source_file

# FILE UPDATES
# create profile
cp -rf $source_dir/templates/.profile ~/
# load profile
source ~/.profile

# continue to bootstrap
bash $source_file
