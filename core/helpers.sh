#!/bin/bash

# sudo helper
function require_sudo() {
    whoami | grep "root" > /dev/null
    if [ $? -eq 1 ] || [ "$1" = "" ]; then
        echo ''
        # keep sudo alive
        [[ ! $password ]] && read -s -p "##### Enter Sudo Password: " password
        echo $password | sudo -v -S
    fi
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