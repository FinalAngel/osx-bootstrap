#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo ''
echo 'OSX Bootstrap Upgrade'
echo '---------------------'
echo ''

# define variables
source_dir=~/.osx-bootstrap
source_file=$source_dir/.osx-bootstrap

# copy file
cp -rf $source_dir/install.sh $source_file && chmod +x $source_file

# continue to bootstrap
bootstrap
