#!/bin/bash

# sudo helper
function require_sudo() {
    if [[ ! `sudo -n uptime 2>&1|grep "load"|wc -l` -gt 0 ]]; then
        echo ''
        # keep sudo alive
        [[ ! $password ]] && read -s -p "##### Enter Password: " password
        echo $password | sudo -S -v

        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi

    echo $password
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

require_sudo