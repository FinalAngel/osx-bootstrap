##### Homebrew Formula: python
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export ARCHFLAGS="-arch x86_64"

##### PIP Configuration: virtualenv
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh

##### Alias Helpers
alias ls="ls -FG"
alias ip="ifconfig | grep netmask | grep -v 127.0.0.1"
alias ws="cd ~/Sites/"
alias venv="source env/bin/activate"
alias denv="deactivate"
alias bootstrap="~/.osx-bootstrap/.osx-bootstrap"

##### Autorun
bash ~/.osx-bootstrap/updater.sh

##### Homebrew Formula: bash_completion
##### Disabled cause of issues with oh-my-zsh
#if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
#  . $(brew --prefix)/etc/bash_completion
#fi
