#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo 'OSX Bootstrap Software'
echo '----------------------'
echo ''

echo 'Warning: this extra is still in development'

# define helpers
source_dir=~/.osx-bootstrap
source $source_dir/core/helpers.sh

# define variables
applications=/Applications/Downloaded
downloads=~/Downloads/TMP
mountpoint=/Volumes/TMP

# TODOS
# http://ftp.postgresql.org/pub/pgadmin3/release/v1.16.1/osx/pgadmin3-1.16.1.dmg#eula
# add synergy
# add https://dl.google.com/googletalk/googletalkplugin/GoogleVoiceAndVideoSetup.dmg pkg installer
export apps='
    http://www.skype.com/go/getskype-macosx.dmg
    http://mirror.switch.ch/ftp/mirror/videolan/vlc/2.0.8/macosx/vlc-2.0.8-intel64.dmg
    http://dl.google.com/drive/installgoogledrive.dmg
    https://d1ilhw0800yew8.cloudfront.net/client/Dropbox%202.2.8.dmg
    https://ccmdls.adobe.com/AdobeProducts/PHSP/14/osx10/AAMmetadataLS20/CreativeCloudInstaller.dmg
    https://dl.google.com/chrome/mac/stable/GoogleChrome.dmg
    http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/22.0/mac/en-US/Firefox%2022.0.dmg
    http://downloads.atlassian.com/software/sourcetree/SourceTree_1.6.2.2.dmg
    http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.dmg
    http://download.jetbrains.com/python/pycharm-2.7.3.dmg
    https://www.valentina-db.com/en/applications-download/valentina-studio?section=files&task=download&cid=13_56d61c59a23f6005c1d7fefdb89f3796
    http://awesome.vanamco.com/downloads/ghostlab/latest/Ghostlab.dmg
    http://download.transmissionbt.com/files/Transmission-2.81.dmg
    http://synergy.googlecode.com/files/synergy-1.4.12-MacOSX108-x86_64.dmg
    http://www.freemacsoft.net/downloads/AppCleaner_2.2.zip
    https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.21.zip
    http://www.irradiatedsoftware.com/download/SizeUp.zip
    http://cachefly.alfredapp.com/Alfred_2.0.7_205.zip
    http://www.codeux.com/textual/private/downloads/builds/trial-versions/Textual-Trial-g441bee9.zip
    http://download.spotify.com/SpotifyInstaller.zip
    http://incident57.com/codekit/files/codekit-8317.zip
    http://www.panic.com/transmit/d/Transmit%204.4.1.zip
    http://cdn.kaleidoscopeapp.com/releases/Kaleidoscope-2.0.1-114.zip
    http://culturedcode.cachefly.net/things/Things_2.2.1.zip
    http://cdn1.evernote.com/skitch/mac/release/Skitch-2.6.2.zip
    http://www.getharvest.com/harvest/mac/Harvest.zip
    http://downloads.hipchat.com.s3.amazonaws.com/osx/HipChat-2.0.zip
    http://download.spotify.com/SpotifyInstaller.zip
    http://lightheadsw.com/files/releases/com.lightheadsw.Caffeine/Caffeine1.1.1.zip
'
for app in $apps
do
    # TODO we should write each app link to a file and read if its already available
    # create tmp dir
    mkdir -p $downloads

    # get infos
    tmp=$(basename $app)
    file=${tmp//%20/}
    ext=${file##*.}

    # download and install
    echo '##### Downloading '$app
    wget $app -q -O $downloads/$file

    # standard dmg
    if [[ $ext = 'dmg' ]]; then
        echo '##### Installing DMG '$file
        hdiutil mount -plist -nobrowse -quiet -mountpoint $mountpoint $downloads/$file
        cp -rf $mountpoint/*.app $applications/
        hdiutil unmount $mountpoint/ -quiet
    fi

    # eula dmg
    if [[ $ext = 'dmg#eula' ]]; then
        echo '##### Installing DMG Eula '$file
        hdiutil convert -quiet $downloads/$file -format UDTO -o $downloads/bar
        hdiutil mount -plist -nobrowse -quiet -mountpoint $mountpoint $downloads/bar.cdr
        cp -rf $mountpoint/*.app $applications/
        hdiutil unmount $mountpoint/ -quiet
    fi

    # standard zip
    if [[ $ext = 'zip' ]]; then
        echo '##### Installing ZIP '$file
        unzip -q $downloads/$file -d $downloads
        cp -rf $downloads/*.app $applications/
    fi

    # cleanup
    rm -rf $downloads
done