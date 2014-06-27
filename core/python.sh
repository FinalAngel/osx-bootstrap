#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# install python
python=`brew list | grep python`
if [[ ! $python ]]; then
    echo ''
    echo '##### Installing Formula Python...'
    brew install python

    # pip installs | after installs are restricted
    pip install --upgrade setuptools
    pip install --upgrade pip
    pip install virtualenv
    pip install virtualenvwrapper
    pip install numpy

    # create profile
    cp -rf $source_dir/templates/.profile ~/
    # load profile
    source ~/.profile
fi

##### remove python manually
# brew uninstall -f python
# rm -rf `brew --cache`
# brew cleanup
# brew prune
# brew doctor