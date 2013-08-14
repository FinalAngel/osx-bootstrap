#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# install oh-my-zsh
if [[ ! -f ~/.zshrc ]]; then
    echo ''
    echo '##### Installing oh-my-zsh...'
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

    # setup zsh
    rm -rf ~/.zshrc

    # create zshrc
    cp -rf $source_dir/templates/.zshrc ~/
fi