#!/bin/bash

# clear terminal screen
clear

# start uninstalling bootstrap
echo "OSX Bootstrap 1.0.0"
echo "-------------------"
echo ""

# ask for sudo password
[[ ! `sudo -n uptime 2>&1|grep "load"|wc -l` -gt 0 ]] && echo '##### Require Password'
sudo -v

echo '##### Uninstall OSX Bootstrap...'
rm -rf ~/.osx-bootstrap

echo '##### Uninstall Homebrew...'
brew update
sudo rm -rf /etc/resolver
sudo rm -rf /usr/local/etc/dnsmasq.conf
bash <(curl -s https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh)

echo '##### Uninstall oh-my-zsh...'
uninstall_oh_my_zsh

echo '##### Uninstall Settings...'
rm -rf ~/.profile
rm -rf ~/.ssh/*
rm -rf ~/Library/LaunchAgents/*

echo '##### Note: ~/Sites will mot be removed'
echo '##### Note: OSX Defaults will not be reset'
echo '##### OSX Bootstrap has been nuked!'