#!/bin/bash

# define helpers
source_dir=~/.osx-bootstrap

# configuring osx
if [[ ! -f ~/.osx-bootstrap/.osx-bootstrap ]]; then
  # Resets the style
  reset=`tput sgr0`

  # General UI/UX
  echo "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "What would you like it to be?"
    read COMPUTER_NAME
    sudo scutil --set ComputerName $COMPUTER_NAME
    sudo scutil --set HostName $COMPUTER_NAME
    sudo scutil --set LocalHostName $COMPUTER_NAME
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
  fi

  echo "Hide the Time Machine, Volume, User, and Bluetooth icons?  (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Get the system Hardware UUID and use it for the next menubar stuff
    for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
      defaults write "${domain}" dontAutoLoad -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/Volume.menu" \
        "/System/Library/CoreServices/Menu Extras/User.menu"
    done

    defaults write com.apple.systemuiserver menuExtras -array \
      "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
      "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
      "/System/Library/CoreServices/Menu Extras/Battery.menu" \
      "/System/Library/CoreServices/Menu Extras/Clock.menu"
  fi

  echo "Hide the Spotlight icon? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
  fi

  echo "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo 'Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.'
    sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
  fi

  echo "Change indexing order and disable some search results in Spotlight? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Yosemite-specific search results (remove them if your are using OS X 10.9 or older):
    #   MENU_DEFINITION
    #   MENU_CONVERSION
    #   MENU_EXPRESSION
    #   MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
    #   MENU_WEBSEARCH             (send search queries to Apple)
    #   MENU_OTHER
    defaults write com.apple.spotlight orderedItems -array \
      '{"enabled" = 1;"name" = "APPLICATIONS";}' \
      '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
      '{"enabled" = 1;"name" = "DIRECTORIES";}' \
      '{"enabled" = 1;"name" = "PDF";}' \
      '{"enabled" = 1;"name" = "FONTS";}' \
      '{"enabled" = 0;"name" = "DOCUMENTS";}' \
      '{"enabled" = 0;"name" = "MESSAGES";}' \
      '{"enabled" = 0;"name" = "CONTACT";}' \
      '{"enabled" = 0;"name" = "EVENT_TODO";}' \
      '{"enabled" = 0;"name" = "IMAGES";}' \
      '{"enabled" = 0;"name" = "BOOKMARKS";}' \
      '{"enabled" = 0;"name" = "MUSIC";}' \
      '{"enabled" = 0;"name" = "MOVIES";}' \
      '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
      '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
      '{"enabled" = 0;"name" = "SOURCE";}' \
      '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
      '{"enabled" = 0;"name" = "MENU_OTHER";}' \
      '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
      '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
      '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
      '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
    # Load new settings before rebuilding the index
    killall mds > /dev/null 2>&1
    # Make sure indexing is enabled for the main volume
    sudo mdutil -i on / > /dev/null
    # Rebuild the index from scratch
    sudo mdutil -E / > /dev/null
  fi

  echo "Expanding the save panel by default"
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  echo "Automatically quit printer app once the print jobs complete"
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
  echo "Displaying ASCII control characters using caret notation in standard text views"
  defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

  echo "Save to disk, rather than iButt, by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToButt -bool false
  fi

  echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  echo "Check for software updates daily, not just once per week"
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

  echo "Removing duplicates in the 'Open With' menu"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

  echo "Disable smart quotes and smart dashes? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  fi

  echo "Add ability to toggle between Light and Dark mode in Yosemite using ctrl+opt+cmd+t? (y/n)"
  # http://www.reddit.com/r/apple/comments/2jr6s2/1010_i_found_a_way_to_dynamically_switch_between/
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
  fi

  echo "Disable Photos.app from starting everytime a device is plugged in"
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


  # General Power and Performance modifications

  echo "Disable hibernation? (speeds up entering sleep mode) (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo pmset -a hibernatemode 0
  fi

  echo "Remove the sleep image file to save disk space? (y/n)"
  echo "(If you're on a <128GB SSD, this helps but can have adverse affects on performance. You've been warned.)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo rm /Private/var/vm/sleepimage
    echo "Creating a zero-byte file instead"
    sudo touch /Private/var/vm/sleepimage
    echo "and make sure it can't be rewritten"
    sudo chflags uchg /Private/var/vm/sleepimage
  fi

  echo "Disable the sudden motion sensor? (it's not useful for SSDs/current MacBooks) (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo pmset -a sms 0
  fi

  echo "Disable system-wide resume? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
  fi

  echo "Disable the menubar transparency? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.universalaccess reduceTransparency -bool true
  fi

  echo "Speeding up wake from sleep to 24 hours from an hour"
  # http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
  sudo pmset -a standbydelay 86400


  ## Trackpad, mouse, keyboard, Bluetooth accessories, and input

  echo "Increasing sound quality for Bluetooth headphones/headsets"
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  echo "Disabling press-and-hold for special keys in favor of key repeat"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  echo "Setting a blazingly fast keyboard repeat rate"
  defaults write NSGlobalDomain KeyRepeat -int 0

  echo "Disable auto-correct? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  fi

  echo "Setting trackpad & mouse speed to a reasonable number"
  defaults write -g com.apple.trackpad.scaling 2
  defaults write -g com.apple.mouse.scaling 2.5

  echo "Turn off keyboard illumination when computer is not used for 5 minutes"
  defaults write com.apple.BezelServices kDimTime -int 300

  echo "Disable display from automatically adjusting brightness? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false
  fi

  echo "Disable keyboard from automatically adjusting backlight brightness in low light? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false
  fi

  # Screen
  echo "Requiring password immediately after sleep or screen saver begins"
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  echo "Where do you want screenshots to be stored? (hit ENTER if you want ~/Desktop as default)"
  # Thanks https://github.com/omgmog
  read screenshot_location
  if [ -z "${screenshot_location}" ]
  then
    # If nothing specified, we default to ~/Desktop
    screenshot_location="${HOME}/Desktop"
  else
    # Otherwise we use input
    if [[ "${screenshot_location:0:1}" != "/" ]]
    then
      # If input doesn't start with /, assume it's relative to home
      screenshot_location="${HOME}/${screenshot_location}"
    fi
  fi
  echo "Setting location to ${screenshot_location}"
  defaults write com.apple.screencapture location -string "${screenshot_location}"

  echo "What format should screenshots be saved as? (hit ENTER for PNG, options: BMP, GIF, JPG, PDF, TIFF) "
  read screenshot_format
  if [ -z "$1" ]
  then
      echo "Setting screenshot format to PNG"
    defaults write com.apple.screencapture type -string "png"
  else
      echo "Setting screenshot format to $screenshot_format"
    defaults write com.apple.screencapture type -string "$screenshot_format"
  fi

  echo "Enabling subpixel font rendering on non-Apple LCDs"
  defaults write NSGlobalDomain AppleFontSmoothing -int 2

  echo "Enabling HiDPI display modes (requires restart)"
  sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

  # Finder
  echo "Show icons for hard drives, servers, and removable media on the desktop? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  fi

  echo "Show hidden files in Finder by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.Finder AppleShowAllFiles -bool true
  fi

  echo "Show dotfiles in Finder by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder AppleShowAllFiles TRUE
  fi

  echo "Show all filename extensions in Finder by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  fi

  echo "Show status bar in Finder by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder ShowStatusBar -bool true
  fi

  echo "Display full POSIX path as Finder window title? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  fi

  echo "Disable the warning when changing a file extension? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  fi

  echo "Use column view in all Finder windows by default? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.finder FXPreferredViewStyle Clmv
  fi

  echo "Avoid creation of .DS_Store files on network volumes? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  fi

  echo "Disable disk image verification? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.frameworks.diskimages skip-verify -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  fi

  echo "Allowing text selection in Quick Look/Preview in Finder by default"
  defaults write com.apple.finder QLEnableTextSelection -bool true

  echo "Show item info near icons on the desktop and in other icon views? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
  fi

  echo "Show item info to the right of the icons on the desktop? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
  fi

  echo "Enable snap-to-grid for icons on the desktop and in other icon views? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  fi

  echo "Increase grid spacing for icons on the desktop and in other icon views? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
  fi

  echo "Increase the size of icons on the desktop and in other icon views? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
  fi

  # Dock & Mission Control
  echo "Wipe all (default) app icons from the Dock? (y/n)"
  echo "(This is only really useful when setting up a new Mac, or if you don't use the Dock to launch apps.)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.dock persistent-apps -array
  fi

  echo "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
  defaults write com.apple.dock tilesize -int 36

  echo "Speeding up Mission Control animations and grouping windows by application"
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock "expose-group-by-app" -bool true

  echo "Disable the over-the-top focus ring animation"
  defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

  echo "Hide the menu bar? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write "Apple Global Domain" "_HIHideMenuBar" 1
  fi

  echo "Set Dock to auto-hide and remove the auto-hiding delay? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
  fi


  # Chrome, Safari, & WebKit
  echo "Privacy: Don't send search queries to Apple"
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  echo "Hiding Safari's bookmarks bar by default"
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  echo "Hiding Safari's sidebar in Top Sites"
  defaults write com.apple.Safari ShowSidebarInTopSites -bool false

  echo "Disabling Safari's thumbnail cache for History and Top Sites"
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

  echo "Enabling Safari's debug menu"
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  echo "Making Safari's search banners default to Contains instead of Starts With"
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

  echo "Removing useless icons from Safari's bookmarks bar"
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"

  echo "Enabling the Develop menu and the Web Inspector in Safari"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

  echo "Adding a context menu item for showing the Web Inspector in web views"
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  echo "Disabling the annoying backswipe in Chrome"
  defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
  defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

  echo "Using the system-native print preview dialog in Chrome"
  defaults write com.google.Chrome DisablePrintPreview -bool true
  defaults write com.google.Chrome.canary DisablePrintPreview -bool true


  # Mail
  echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  # Terminal
  echo "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default"
  defaults write com.apple.terminal StringEncodings -array 4
  defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
  defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"


  # Time Machine
  echo "Prevent Time Machine from prompting to use new hard drives as backup volume? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
  fi

  echo "Disable local Time Machine backups? (This can take up a ton of SSD space on <128GB SSDs) (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    hash tmutil &> /dev/null && sudo tmutil disablelocal
  fi


  # Messages        
  echo "Disable automatic emoji substitution in Messages.app? (i.e. use plain text smileys) (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
  fi

  echo "Disable smart quotes in Messages.app? (it's annoying for messages that contain code) (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
  fi

  echo "Disable continuous spell checking in Messages.app? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
  fi


  # Transmission.app
  echo "Do you use Transmission for torrenting? (y/n)"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p ~/Downloads/Incomplete

    echo "Setting up an incomplete downloads folder in Downloads"
    defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
    defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"

    echo "Setting auto-add folder to be Downloads"
    defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"

    echo "Don't prompt for confirmation before downloading"
    defaults write org.m0k.transmission DownloadAsk -bool false

    echo "Trash original torrent files after adding them"
    defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

    echo "Hiding the donate message"
    defaults write org.m0k.transmission WarningDonate -bool false

    echo "Hiding the legal disclaimer"
    defaults write org.m0k.transmission WarningLegal -bool false
    
    echo "Auto-resizing the window to fit transfers"
    defaults write org.m0k.transmission AutoSize -bool true

    echo "Auto updating to betas"
    defaults write org.m0k.transmission AutoUpdateBeta -bool true

    echo "Setting up the best block list"
    defaults write org.m0k.transmission EncryptionRequire -bool true
    defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
    defaults write org.m0k.transmission BlocklistNew -bool true
    defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
  fi


  # Sublime Text
  echo "Do you use Sublime Text 3 as your editor of choice, and is it installed?"
  read -r response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Installing from homebrew cask does the following for you!
    #   # echo "Linking Sublime Text for command line usage as subl"
    ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

    echo "Setting Git to use Sublime Text as default editor"
    git config --global core.editor "subl -n -w"
  fi

  # Create a nice last-change git log message, from https://twitter.com/elijahmanor/status/697055097356943360
  git config --global alias.lastchange 'log -p --follow -n 1'

  find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
  for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
    "Terminal" "Transmission"; do
    killall "${app}" > /dev/null 2>&1
  done
fi
