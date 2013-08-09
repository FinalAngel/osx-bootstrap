#!/bin/bash

# clear terminal screen
clear

# start uninstalling bootstrap
echo 'OSX Bootstrap Nuke'
echo '------------------'
echo ''

# define helpers
source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source /dev/stdin <<< "$(curl --insecure -s $source_dir/core/helpers.sh)"

# require sudo password
require_sudo

# core/system.sh
echo '##### Uninstall core/system'
echo '##### Note: ~/Sites will not be removed!'
rm -rf ~/.osx-bootstrap

# core/brew.sh
echo '##### Uninstall core/brew'
brew update
bash <(curl -s https://gist.github.com/mxcl/1173223/raw/a833ba44e7be8428d877e58640720ff43c59dbad/uninstall_homebrew.sh)
rm -rf /usr/local/Cellar
rm -rf /usr/local/.git
rm -rf /Library/Caches/Homebrew
# templates
sudo rm -rf /etc/resolver
sudo rm -rf /usr/local/etc/dnsmasq.conf
# agents
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo rm -rf /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
rm -rf ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
# updates
dscacheutil -flushcache

# core/python
echo '##### Uninstall core/python'
rm -rf ~/.profile
exec bash
# pip uninstalls
pip uninstall virtualenv
pip uninstall virtualenvwrapper
pip uninstall numpy

# core/mysql
echo '##### Uninstall core/mysql'
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
rm -rf ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

# core/compass
echo '##### Uninstall core/compass'
sudo gem uninstall compass

# core/zsh
echo '##### Uninstall core/zsh'
bash ~/oh-my-zsh/tools/uninstall.sh

# core/defaults
echo '##### Uninstall core/defaults'
echo '##### Note: OSX defaults will remain!'

# core/github
echo '##### Uninstall core/github'
echo '##### Note: Github settings will remain!'
rm -rf ~/.ssh/*

echo '##### OSX Bootstrap has been successfully uninstalled!'