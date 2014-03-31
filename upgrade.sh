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
# sudo keepalive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# define variables
source_dir=~/.osx-bootstrap
source_file=$source_dir/.osx-bootstrap

# copy file
cp -rf $source_dir/install.sh $source_file && chmod +x $source_file

# continue to bootstrap
bash $source_file
