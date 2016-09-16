#!/bin/bash

# clear terminal screen
clear

# define variables
declare version='1.6.2'
declare update=true
declare source_dir=~/.osx-bootstrap
declare source_file=$source_dir/.osx-bootstrap
declare source_file_tmp=$source_dir/.osx-bootstrap-tmp

# sudo keepalive
startsudo() {
    sudo -v
    ( while true; do sudo -v; sleep 60; done; ) &
    SUDO_PID="$!"
    trap stopsudo SIGINT SIGTERM
}
stopsudo() {
    kill "$SUDO_PID"
    trap - SIGINT SIGTERM
    sudo -k
}

startsudo
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

# should we update
[[ update ]] && cp -rf $source_dir/install.sh $source_file_tmp && chmod +x $source_file

# clear terminal screen
clear

# start bootstrap
echo '-------------------'
echo 'OSX Bootstrap' $version
echo '-------------------'

# create bootstrap tmp
[[ ! -f $source_file ]] && cp -rf $source_dir/install.sh $source_file_tmp
# update timestamp
echo 'LAST_EPOCH=$(_current_epoch)' > ~/.osx-bootstrap/.osx-update

# include system with param $1
source $source_dir/core/system.sh $1
# install brew
(stopsudo && source $source_dir/core/brew.sh)
# install python
source $source_dir/core/python.sh
# install mysql
source $source_dir/core/mysql.sh
# install postgres
source $source_dir/core/postgres.sh
# install node/npm
source $source_dir/core/npm.sh
# install zsh
source $source_dir/core/zsh.sh
# install defaults
source $source_dir/core/defaults.sh
# install github
source $source_dir/core/github.sh
# place your extras here

# create bootstrap file
[[ ! -f $source_file || -f $source_file_tmp ]] && mv $source_file_tmp $source_file && chmod +x $source_file

stopsudo

# done
echo ''
cowsay 'Bootstrapp Ready!'
echo ''

# reboot after installation is done
`sudo fdesetup isactive`
if [[ $? != 0 ]]; then
    read -p "##### Do you want to reboot? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ''
        sudo reboot
    fi
fi
