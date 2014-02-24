=============
OSX Bootstrap
=============

1.3.0
-----
- added more instructions for command line tools installation on mavericks
- moved core/compass to extras
- changed secure empty trash to false as it's annoying
- fixed an issue with npm paths and added bower and grunt as defaults

1.2.5
-----
- fixed sudo alive

1.2.4
-----
- added upgrade file
- fixed an issue with postgres throttling and added source
- fixed an issue with git config --global github.user
- fixed homebrew install url
- removed mysql-connector-c dependency

1.2.3
-----
- fixed issues with extras/npm.sh
- fixed issues with extras/ruby.sh

1.2.2
-----
- added brew redis
- added brew formula geoip
- fixes an issue with postgis template

1.2.1
-----
- fixed an issue with postgres throttling respawn
- fixed dynamic path within system.sh
- added sudo keep-alive
- added update to software extra

1.2.0
-----
- adds bootstrap shortcut
- refactor installation to download the repo
- fixes issues with core modules
- fixes issues with extras modules
- fixed an issue with ordering in brew.sh
- fixed an issue with ordering in python.sh
- fixed an issue with LaunchAgents
- added extra npm
- added install.sh

1.1.0
-----
- restructure to core modules
- added template folder for setup files
- added global helpers function script
- added brew formula foreman
- added extra heroku
- added extra ruby
- fixed extra php

1.0.1
-----
- cleanup of extras folder
- fixed an issue with sudo on etc/resolver
- added venv alias
- added denv alias
- added valentia studio in favor of mysqlworkbench and pgadmin3
- added gem compass
- added formula git-flow

1.0.0
-----
- initial release
