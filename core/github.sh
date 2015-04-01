#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

if [[ ! -f ~/.ssh/id_rsa ]]; then
    echo ''
    echo '##### Please enter your github username: '
    read github_user
    echo '##### Please enter your github email address: '
    read github_email

    # setup github
    if [[ $github_user && $github_email ]]; then
        # setup config
        git config --global user.name $github_user
        git config --global user.email $github_email
        git config --global github.user $github_user
        git config --global github.token your_token_here
        git config --global color.ui true
        git config --global push.default current
        # sublime support
        # git config --global core.editor "subl -w"

        # set rsa key
        curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
        chmod u+x git-credential-osxkeychain
        sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
        git config --global credential.helper osxkeychain

        # generate ssh key
        cd ~/.ssh
        ssh-keygen -t rsa -C $github_email
        pbcopy < ~/.ssh/id_rsa.pub
        echo ''
        echo '##### The following rsa key has been copied to your clipboard: '
        cat ~/.ssh/id_rsa.pub
        echo '##### Follow step 4 to complete: https://help.github.com/articles/generating-ssh-keys'
        ssh -T git@github.com
    fi
fi
