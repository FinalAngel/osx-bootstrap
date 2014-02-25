#!/bin/bash

# clear terminal screen
clear

# start uninstalling bootstrap
echo 'OSX Bootstrap Nuke'
echo '------------------'
echo ''

# define helpers
declare source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# ensure you want to remove all components
read -p "##### Are you sure you want to remove osx-bootstrap? [Yn]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ''
    exit
fi

# require sudo password
require_sudo

# core/brew.sh
echo ''
echo '##### Uninstall core/brew'
cd `brew --prefix`
rm -rf Cellar
brew prune
rm `git ls-files`
rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
rm -rf /Library/Caches/Homebrew
rm -rf /usr/local/Cellar
rm -rf /usr/local/.git
rm -rf /usr/local/bin/brew
# templates
rm -rf /usr/local/etc
sudo rm -rf /etc/resolver
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
# pip uninstalls
pip uninstall virtualenv
pip uninstall virtualenvwrapper
pip uninstall numpy

# core/mysql
echo '##### Uninstall core/mysql'
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
rm -rf ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

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

# core/system.sh
echo '##### Uninstall core/system'
echo '##### Note: ~/Sites will not be removed!'
rm -rf ~/.osx-bootstrap

# done
echo '##### OSX Bootstrap has been successfully uninstalled!'
