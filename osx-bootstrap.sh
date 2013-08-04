#!/bin/bash

# clear terminal screen
clear

# autoupdate bootstrap file
wget https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh -O ~/.osx-bootstrap-tmp -q

# start bootstrap
echo "OSX Bootstrap 1.0.0"
echo "-------------------"
echo ""

# ask for sudo password
[[ ! `sudo -n uptime 2>&1|grep "load"|wc -l` -gt 0 ]] && echo '##### Require Password'
sudo -v

# defaults
hostname=$1 && [ ! $1 ] && hostname='osx-'`whoami`

# set hostname
if [[ ! -f ~/.osx-bootstrap ]]; then
    echo '##### Setting Computer Name'
    sudo scutil --set ComputerName $hostname
    sudo scutil --set HostName $hostname
    sudo scutil --set LocalHostName $hostname
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $hostname
fi

# ensure FileVault is active
`sudo fdesetup isactive`
if [[ $? != 0 ]]; then
    read -p "##### Do you want to enable Disk Encryption? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ''
        sudo fdesetup enable
    else
        echo ''
    fi
fi

# update osx version
echo '##### Running OSX Software Updates...'
sudo softwareupdate -i -a

# update gem versions
echo '##### Running Ruby Gem Updates...'
sudo gem update --system

# install homebrew
`which -s brew`
if [[ $? != 0 ]]; then
    echo '##### Installing Homebrew...';
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    brew update
    brew doctor
else
    echo '##### Running Homebrew Updates...'
    brew update
    brew doctor
fi

# install helpfull formulas
export formulas='
    git 
    hub 
    bash-completion
    ssh-copy-id
    wget
    dnsmasq
    nginx
    cowsay
'
for formula in $formulas
do
    tmp=`brew list | grep $formula`
    if [[ ! $tmp ]]; then
        echo '##### Installing Formula '$formula'...'
        brew install $formula

        write file | adds bash completion settings
        activate when not using oh-my-zsh
        if [[ $formula = 'bash-completion' ]]; then
           echo '##### Homebrew Formula: '$formula >> ~/.profile
           echo '#if [[ -f $(brew --prefix)/etc/bash_completion ]]; then' >> ~/.profile
           echo '#  . $(brew --prefix)/etc/bash_completion' >> ~/.profile
           echo '#fi' >> ~/.profile
           echo '' >> ~/.profile
           . ~/.profile
        fi

        if [[ $formula = 'dnsmasq' ]]; then
            # setup dnsmask
            # cp /usr/local/opt/dnsmasq/dnsmasq.conf.example /usr/local/etc/dnsmasq.conf
            mkdir /usr/local/etc/ &&
            echo '##### Homebrew Formula: '$formula >> /usr/local/etc/dnsmasq.conf
            echo 'address=/dev/127.0.0.1' >> /usr/local/etc/dnsmasq.conf
            echo 'address=/stage/192.168.10.200' >> /usr/local/etc/dnsmasq.conf
            echo 'listen-address=127.0.0.1' >> /usr/local/etc/dnsmasq.conf

            # setup dnsmask daemon
            ln -sfv /usr/local/opt/dnsmasq/*.plist ~/Library/LaunchAgents
            launchctl load ~/Library/LaunchAgents/homebrew.mxcl.dnsmasq.plist

            # setup resolver
            sudo mkdir -p /etc/resolver
            sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
            dscacheutil -flushcache
            # scutil --dns
        fi

        if [[ $formula = 'nginx' ]]; then
            ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
            launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
        fi
    fi
done

# install python
python=`brew list | grep python`
if [[ ! $python ]]; then
    echo '##### Installing Formula Python...'
    brew install python

    # writing file | add python path
    echo '##### Homebrew Formula: python' >> ~/.profile
    echo 'export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH' >> ~/.profile
    echo 'export ARCHFLAGS="-arch x86_64"' >> ~/.profile
    echo '' >> ~/.profile
    . ~/.profile

    # pip installs | after installs are restricted
    pip install --upgrade setuptools
    pip install --upgrade pip
    pip install virtualenv
    pip install virtualenvwrapper
    pip install numpy

    # write file | use pip only in virtualenvs
    echo '##### PIP Configuration: virtualenv' >> ~/.profile
    echo 'export PIP_REQUIRE_VIRTUALENV=true' >> ~/.profile
    echo 'export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache' >> ~/.profile
    echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python' >> ~/.profile
    echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.profile
    echo '' >> ~/.profile
    #write aliases
    echo 'alias ls="ls -FG"' >> ~/.profile
    echo 'alias ip="ifconfig | grep netmask | grep -v 127.0.0.1"' >> ~/.profile
    echo 'alias ws="cd ~/Sites/"' >> ~/.profile
    echo '' >> ~/.profile
    . ~/.profile

    # setup workspace
    mkdir -p ~/Sites
fi

# install mysql
mysql=`brew list | grep mysql`
if [[ ! $mysql ]]; then
    echo '##### Installing Formula MySQL...'
    brew install mysql
    brew install mysql-connector-c

    # link connector
    brew link --overwrite mysql-connector-c

    # setup mysql
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
fi

# install postgres
postgres=`brew list | grep postgres`
if [[ ! $postgres ]]; then
    echo '##### Installing Formula Postgres...'
    
    PYTHON=/usr/local/bin/python brew install postgres

    # setup postgres
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    initdb /usr/local/var/postgres -E utf8

    # brew installs
    brew install postgis

    # brew fixes
    brew unlink libxml2
    
    # setup postgres
    createuser postgres -s

    # setup postgis
    createdb template_postgis
    createlang plpgsql template_postgis
fi

# install oh-my-zsh
`which -s zsh`
if [[ $? != 0 ]]; then
    echo '##### Installing oh-my-zsh...'
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

    # setup zsh
    rm ~/.zshrc

    echo 'ZSH=$HOME/.oh-my-zsh' >> ~/.zshrc
    echo 'ZSH_THEME="robbyrussell"' >> ~/.zshrc
    echo 'plugins=(git osx rails ruby github node npm brew)' >> ~/.zshrc
    echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
    echo '[[ -e ~/.profile ]] && emulate sh -c "source ~/.profile"' >> ~/.zshrc
fi

# configuring osx
if [[ ! -f ~/.osx-bootstrap ]]; then
    echo '##### Configuring OSX...'

    # ask for sudo password
    [[ ! `sudo -n uptime 2>&1|grep "load"|wc -l` -gt 0 ]] && echo '##### Require Password'
    sudo -v

    # Enabling subpixel font rendering on non-Apple LCDs
    defaults write NSGlobalDomain AppleFontSmoothing -int 2
    # Enable full keyboard access for all controls
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Set a shorter Delay until key repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 12
    # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 0
    # Disable window animations
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    # I don't even... (disabling auto-correct)
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    # Disable automatic termination of inactive apps
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
    # Expanding the save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    # Disable Resume system-wide
    defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
    # Display ASCII control characters using caret notation in standard text views
    defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
    # Increasing the window resize speed for Cocoa applications whether you like it or not
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

    # FINDER
    # Show dotfiles in Finder
    defaults write com.apple.finder AppleShowAllFiles TRUE
    # Setting Trash to empty securely by default
    defaults write com.apple.finder EmptyTrashSecurely -bool true
    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # show litsview as default
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv
    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Show absolute path in finder's title bar
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
    # Allow text selection in Quick Look/Preview
    defaults write com.apple.finder QLEnableTextSelection -bool true
    # Show Path bar in Finder
    defaults write com.apple.finder ShowPathbar -bool true
    # Show Status bar in Finder
    defaults write com.apple.finder ShowStatusBar -bool true
    # Avoiding creating stupid .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    # Show the ~/Library folder
    chflags nohidden ~/Library

    # DESKTOP & DOCK
    # Enable snap-to-grid for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    # Set the icon size of Dock items to 36 pixels
    defaults write com.apple.dock tilesize -int 36
    # Speeding up Mission Control animations and grouping windows by application
    defaults write com.apple.dock expose-animation-duration -float 0.1
    defaults write com.apple.dock "expose-group-by-app" -bool true
    # Enabling iTunes track notifications in the Dock
    defaults write com.apple.dock itunes-notifications -bool true
    # Show indicator lights for open applications in the Dock
    defaults write com.apple.dock show-process-indicators -bool true
    # Wipe all (default) app icons from the Dock
    # defaults write com.apple.dock persistent-apps -array
    # Reset Launchpad
    find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete

    # SAFARI
    # Disabling Safari’s thumbnail cache for History and Top Sites
    defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    # Removing useless icons from Safari’s bookmarks bar
    defaults write com.apple.Safari ProxiesInBookmarksBar "()"
    # Enabling the Develop menu and the Web Inspector in Safari
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
    # Adding a context menu item for showing the Web Inspector in web views
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    # TERMINAL
    # Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default
    defaults write com.apple.Terminal StringEncodings -array 4
    defaults write com.apple.Terminal ShellExitAction 2
    defaults write com.apple.Terminal FontAntialias 1
    defaults write com.apple.Terminal Shell "/bin/zsh"
    defaults write com.apple.Terminal "Default Window Settings" "Pro"
    defaults write com.apple.Terminal "Startup Window Settings" "Pro"

    # TIME MACHINE
    # Preventing Time Machine from prompting to use new hard drives as backup volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
    # Disabling local Time Machine backups
    hash tmutil &> /dev/null && sudo tmutil disablelocal

    # SECURITY
    # Requiring password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # OTHER
    # Deleting space hogging sleep image and disabling
    sudo rm /private/var/vm/sleepimage
    sudo pmset -a hibernatemode 0
    # Speed up wake from sleep to 24 hours from an hour
    # http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
    sudo pmset -a standbydelay 86400
    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    # Increasing sound quality for Bluetooth headphones/headsets, because duhhhhh
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
    # disable guest user
    sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
    # Enable AirDrop over Ethernet and on unsupported Macs running Lion
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

    #  killall
    for app in Finder Dock Mail Safari iTunes
    do
        killall "$app" > /dev/null 2>&1
    done
fi

if [[ ! -f ~/.ssh/id_rsa ]]; then
    echo '##### Almost done!'
    echo '##### Please enter your github username: '
    read github_user
    echo '##### Please enter your github email address: '
    read github_email

    # setup github
    if [[ $github_user && $github_email ]]; then
        # setup config
        git config --global user.name $github_user
        git config --global user.email $github_email
        git config --global github.user g3d
        git config --global github.token your_token_here
        git config --global core.editor "subl -w"
        git config --global color.ui true
        git config --global push.default matching

        # set rsa key
        curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
        chmod u+x git-credential-osxkeychain
        sudo mv git-credential-osxkeychain "$(dirname $(which git))/git-credential-osxkeychain"
        git config --global credential.helper osxkeychain

        # generate ssh key
        cd ~/.ssh
        ssh-keygen -t rsa -C $github_email
        pbcopy < ~/.ssh/id_rsa.pub
        echo '##### The following rsa key has been copied to your clipboard: '
        cat ~/.ssh/id_rsa.pub
        echo '##### Follow step 3 to complete: https://help.github.com/articles/generating-ssh-keys'
        ssh -T git@github.com
    fi
fi

# ensure bootstrap is ready
[[ -f ~/.osx-bootstrap-tmp ]] && mv ~/.osx-bootstrap-tmp ~/.osx-bootstrap && chmod +x ~/.osx-bootstrap

# done
echo ""
cowsay 'Bootstrapp Ready!'
echo ""

# reboot?
`sudo fdesetup isactive`
if [[ $? != 0 ]]; then
    read -p "##### Do you want to reboot? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ''
        sudo reboot
    fi
fi