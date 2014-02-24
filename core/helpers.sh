#!/bin/bash

# sudo helper
function require_sudo() {
    whoami | grep "root" > /dev/null
    if [ $? -eq 1 ] || [ "$1" = "" ]; then
        echo ""
        echo "##### Enter Sudo Password: "
        sudo -v
         
        # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
         
        # Example: do stuff over the next 30+ mins that requires sudo here or there.
        function wait() {
            echo -n "["; for i in {1..60}; do sleep $1; echo -n =; done; echo "]"
        }
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