#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    printf "\n##### Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    printf "\n##### Running Homebrew Updates..."
    brew update
    brew doctor
fi

# install helpfull formulas
formulas=(
    git
    git-flow
    hub
    bash-completion
    ssh-copy-id
    wget
    dnsmasq
    nginx
    cowsay
    redis
    geoip
    freetype
    libtiff
    webp
    openjpeg
    little-cms2
    watch
    gettext
    closure-compiler
    node
    mysql
)

for i in "${array[@]}"
do
    brew install $i
done


# setup dnsmask
mkdir /usr/local/etc/
cp -rf $source_dir/templates/dnsmasq.conf /usr/local/etc

# setup dnsmask daemon
sudo ln -sfv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

# setup resolver
sudo mkdir -p /etc/resolver
sudo cp -rf $source_dir/templates/dev /etc/resolver
# empty cache
dscacheutil -flushcache
# scutil --dns

ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
            
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
            
ln -s /usr/local/Cellar/gettext/*/bin/msgfmt /usr/local/bin/msgfmt
