##### Homebrew Formula: oh-my-zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git osx rails ruby github node npm brew)
source $ZSH/oh-my-zsh.sh
[[ -e ~/.profile ]] && emulate sh -c "source ~/.profile"
