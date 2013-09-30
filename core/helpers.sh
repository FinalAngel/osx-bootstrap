#!/bin/bash

# sudo helper
function require_sudo() {
    echo '' && echo '##### Require Password'
    # keep sudo alive
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

# helper function for reboot
function require_reboot() {
    # requires password
    require_sudo

    `sudo fdesetup isactive`
    if [[ $? != 0 ]]; then
        read -p "##### Do you want to reboot? [Yn]" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo ''
            sudo reboot
        fi
    fi
}