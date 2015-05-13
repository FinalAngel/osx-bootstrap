#!/bin/bash

function request_password() {
    read -s -p "Write your password: " PASSWD
    export PASSWD
}

function sudo() {
    (echo PASSWD | $(which sudo) -S $@) >/dev/null
}
