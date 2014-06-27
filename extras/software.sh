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

# define variables
applications=/Applications/Downloaded
downloads=~/Downloads/TMP
mountpoint=/Volumes/TMP
software=$source_dir/templates/software.txt

while read line; do
    # strip empty lines and comments
    if [[ $line != *'# '* && $line != '' ]]; then
        
        # TODO we should write each app link to a file and read if its already available
        # create tmp dir
        mkdir -p $downloads

        # get app links
        prefix=$(basename $line)
        app=${line/$prefix/}
        label=${prefix/:/}

        # get app properties
        tmp=$(basename $app)
        file=${tmp//%20/}
        ext=${file##*.}

        # download and install
        echo '##### Downloading '$label
        wget $app -q -O $downloads/$file

        # standard dmg
        if [[ $ext = 'dmg' ]]; then
            echo '##### Installing DMG '$file
            hdiutil mount -plist -nobrowse -quiet -mountpoint $mountpoint $downloads/$file
            cp -rf $mountpoint/*.app $applications/
            hdiutil unmount $mountpoint/ -quiet
        fi

        # eula dmg
        # register using pgadmin3-1.16.1.dmg#eula
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

    fi
done < $source_dir/templates/software.txt