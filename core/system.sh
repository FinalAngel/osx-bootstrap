#!/bin/bash

# define helpers
source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source <(curl -s $source_dir/core/helpers.sh)

# require sudo password
require_sudo

# set hostname
if [[ ! -f ~/.osx-bootstrap ]]; then
    echo '##### Setting Computer Name'
    # define hostname
    hostname=$1 && [ ! $1 ] && hostname='osx-'`whoami`
    # set hostname
    sudo scutil --set ComputerName $hostname
    sudo scutil --set HostName $hostname
    sudo scutil --set LocalHostName $hostname
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $hostname
fi

# ensure FileVault is active
`sudo fdesetup isactive`
if [[ $? != 0 ]]; then
    read -p "##### Do you want to enable Disk Encryption? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ''
        sudo fdesetup enable
    else
        echo ''
    fi
fi

# setup workspace
if [[ ! -d ~/Sites ]]; then
    mkdir -p ~/Sites
fi

echo '##### Running OSX Software Updates...'
sudo softwareupdate -i -a

# update gem versions
echo '##### Running Ruby Gem Updates...'
sudo gem update --system