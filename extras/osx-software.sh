#!/bin/bash

# clear terminal screen
clear

# start bootstrap
echo "OSX Software 1.0.0"
echo "------------------"
echo ""

# installing dmg files
echo '##### Installing Software...'

applications=/Applications/Downloaded
downloads=~/Downloads/TMP
mountpoint=/Volumes/TMP

export apps='
    http://www.skype.com/go/getskype-macosx.dmg
    http://ftp.postgresql.org/pub/pgadmin3/release/v1.16.1/osx/pgadmin3-1.16.1.dmg#eula
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