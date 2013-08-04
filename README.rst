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

#. Open a terminal and run ``bash <(curl -s http://goo.gl/wVmcPW)``
#. Add your RSA key (``cat ~/.ssh/id_rsa.pub``) into your Github account under ``SSH Keys``
#. Run addtional bootstraps like ``osx-software.sh`` or ``osx-projects.sh``

You will need to enter your **sudo password** and **github information** during the installation process.

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

#. run ``~/.osx-bootstrap`` to autoupdate your system
#. run ``~/.osx-bootstrap nuke`` to uninstall osx-bootstrap