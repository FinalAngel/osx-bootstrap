#!/bin/sh

function _current_epoch() {
    echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_osx_update() {
    echo "LAST_EPOCH=$(_current_epoch)" > ~/.osx-bootstrap/.osx-update
}

function _upgrade_osx() {
    ~/.osx-bootstrap/.osx-bootstrap
}

epoch_target=$UPDATE_OSX_DAYS
if [[ -z "$epoch_target" ]]; then
    # Default to old behavior
    epoch_target=13
fi

if [ -f ~/.osx-bootstrap/.osx-update ]
then
    . ~/.osx-bootstrap/.osx-update

    if [[ -z "$LAST_EPOCH" ]]; then
        _update_osx_update && return 0;
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]
    then
        if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
        then
            _upgrade_osx
        else
            echo "OSX Bootstrap would like to check for updates?"
            echo "Type Y to update:"
            read line
            if [ "$line" = Y ] || [ "$line" = y ]; then
                _upgrade_osx
            else
                _update_osx_update
            fi
        fi
    fi
else
    # create the update file
    _update_osx_update
fi
