=============
OSX Bootstrap
=============

This is a bash script designed for divio macs running **OSX Mountain Lion**.


Requirements
------------

#. Install a **fresh** version of OSX Mountain Lion (10.8)
#. Install Xcode from the Mac App Store
#. Start Xcode, open ``Xcode > Preferences > Downloads`` and install the **Command Line Tools**


Install Bootstrap
-----------------

#. Open a terminal and run ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh)``
#. Add your RSA key (``cat ~/.ssh/id_rsa.pub``) into your Github account under ``SSH Keys``
#. Run addtional bootstraps like ``osx-software.sh`` or ``osx-projects.sh``

You will need to enter your **sudo password** and **github information** during the installation process.

The default hostname will be set to **osx-`whoami`** you can overwrite this by adding the desired hostname using: ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh) divio-computer``

The following configuration will be set:

* Disc Encryption
* Softwareupdates
* Computer Hostname
* Git & Github
* OSX Defaults

The following packages will be installed:

* Homebrew
* Formulas: git, hub, bash-completion, ssh-copy-id, wget, dnsmasq, nginx, cowsay, 
  python, mysql, postgres, postgis and their requirements
* PIP installs: virtualenv, virtualenvwrapper, numpy
* oh-my-zsh

Additionally ``~/.profile`` and ``~/.zshrc`` will be setup for you.


Using Bootstrap
---------------

#. run ``~/.osx-bootstrap`` to autoupdate your system from time to time
#. run ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap-nuke.sh)`` to uninstall osx-bootstrap (not working yet)