#!/bin/bash

# define helpers
source_dir='https://raw.github.com/divio/osx-bootstrap/master'
source <(curl -s $source_dir/core/helpers.sh)

# install python
python=`brew list | grep python`
if [[ ! $python ]]; then
    echo '##### Installing Formula Python...'
    brew install python

    # create profile
    cp -rf $source_dir/templates/.profile ~/
    # load profile
    source ~/.profile

    # pip installs | after installs are restricted
    pip install --upgrade setuptools
    pip install --upgrade pip
    pip install virtualenv
    pip install virtualenvwrapper
    pip install numpy
fi