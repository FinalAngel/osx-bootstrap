#!/bin/bash

# define helpers
source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source /dev/stdin <<< "$(curl --insecure -s $source_dir/core/helpers.sh)"

# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    echo '##### Installing Homebrew...'
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    brew update
    brew doctor
else
    echo '##### Running Homebrew Updates...'
    brew update
    brew doctor
fi

# install helpfull formulas
export formulas='
    git
    git-flow
    hub
    bash-completion
    ssh-copy-id
    wget
    dnsmasq
    nginx
    cowsay
'
for formula in $formulas
do
    tmp=`brew list | grep $formula`
    if [[ ! $tmp ]]; then
        echo '##### Installing Formula '$formula'...'
        brew install $formula

        if [[ $formula = 'dnsmasq' ]]; then
            # setup dnsmask
            mkdir /usr/local/etc/
            cp -rf $source_dir/templates/dnsmasq.conf /usr/local/etc

            # sudo is required for dnsmasq
            require_sudo

            # setup dnsmask daemon
            sudo ln -sfv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
            sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

            # setup resolver
            sudo mkdir -p /etc/resolver
            sudo cp -rf $source_dir/templates/dev /etc/resolver
            # empty cache
            dscacheutil -flushcache
            # scutil --dns
        fi

        if [[ $formula = 'nginx' ]]; then
            ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
            launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
        fi
    fi
done