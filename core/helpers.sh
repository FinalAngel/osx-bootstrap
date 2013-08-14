#!/bin/bash

# sudo helper
function require_sudo() {
    [[ ! `sudo -n uptime 2>&1|grep "load"|wc -l` -gt 0 ]] && echo '' && echo '##### Require Password'
    sudo -v
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