#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# configuring osx
if [[ ! -f ~/.osx-bootstrap/.osx-bootstrap ]]; then
    echo ''
    echo '##### Configuring OSX...'

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
    # always show scrollbars
    defaults write NSGlobalDomain AppleShowScrollBars -string “Always”
    # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 0
    # Disable window animations
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
    # I don't even... (disabling auto-correct)
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    # Disable automatic termination of inactive apps
    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
    # Save to disk (not to iCloud) by default
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    # Expanding the save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    # Disable smooth scrolling
    defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
    # Disable Resume system-wide
    defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
    # Display ASCII control characters using caret notation in standard text views
    defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
    # Increasing the window resize speed for Cocoa applications whether you like it or not
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    # Disable “natural” (Lion-style) scrolling
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

    # FINDER
    # Show dotfiles in Finder
    defaults write com.apple.finder AppleShowAllFiles TRUE
    # Setting Trash to empty securely not by default
    defaults write com.apple.finder EmptyTrashSecurely -bool false
    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # show litsview as default
    defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"
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
    # Disable dashboard
    defaults write com.apple.dashboard mcx-disabled -boolean YES
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
    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true
    # Add a spacer to the left and right side of the Dock (where the applications are)
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
    defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'
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
    # Enable Assistive Devices 
    sudo touch /private/var/db/.AccessibilityAPIEnabled
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
    # show remaining battery time
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"
    # Automatically illuminate built-in MacBook keyboard in low light
    defaults write com.apple.BezelServices kDim -bool true
    # Turn off keyboard illumination when computer is not used for 5 minutes
    defaults write com.apple.BezelServices kDimTime -int 300
    # Disable the Ping sidebar in iTunes
    defaults write com.apple.iTunes disablePingSidebar -bool true
    defaults write com.apple.iTunes disablePing -bool true

    #  killall
    for app in Finder Dock Mail Safari iTunes
    do
        killall "$app" > /dev/null 2>&1
    done
fi