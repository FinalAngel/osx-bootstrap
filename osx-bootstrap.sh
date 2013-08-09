#!/bin/bash

# clear terminal screen
clear

# autoupdate bootstrap file
curl -o ~/.osx-bootstrap-tmp https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh

# start bootstrap
echo ''
echo 'OSX Bootstrap 1.1.0'
echo '-------------------'
echo ''

# define helpers
$source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source $source_dir/core/helpers.sh

# include system with param $1
bash $source_dir/core/system.sh $1
# install brew
bash $source_dir/core/brew.sh
# install python
bash $source_dir/core/python.sh
# install mysql
bash $source_dir/core/mysql.sh
# install postgres
bash $source_dir/core/postgres.sh
# install compass
bash $source_dir/core/compass.sh
# install zsh
bash $source_dir/core/zsh.sh
# install defaults
bash $source_dir/core/defaults.sh
# install github
bash $source_dir/core/github.sh

# ensure bootstrap is ready
[[ -f ~/.osx-bootstrap-tmp ]] && mv ~/.osx-bootstrap-tmp ~/.osx-bootstrap && chmod +x ~/.osx-bootstrap

# done
echo ''
cowsay 'Bootstrapp Ready!'
echo ''

# call helper function from libs/system.sh
require_reboot
