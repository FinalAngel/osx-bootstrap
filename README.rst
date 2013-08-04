=============
OSX Bootstrap
=============

This is a bash script automating configuration and installation of **OSX Mountain Lion** workstations.


Requirements
------------

#. Install a **fresh** version of OSX Mountain Lion (10.8)
#. Install Xcode from the Mac App Store
#. Start Xcode, open ``Xcode > Preferences > Downloads`` and install the **Command Line Tools**


Install Bootstrap
-----------------

#. | Open a terminal and run:
   | ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh)``
#. | Run addtional bootstraps like:
   | ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/extras/osx-software.sh)``
   | ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/extras/osx-projects.sh)``
#. | Add your RSA key (``cat ~/.ssh/id_rsa.pub``) into your github.com account under ``SSH Keys``

You will need to enter your **sudo password** and **github information** during the installation process.

| The default hostname will be set to **osx-`whoami`** you can overwrite this by adding the desired hostname using:
| ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap.sh) my-computer``


About Bootstrap
---------------

The following configurations will be automated:

* Disc Encryption
* Softwareupdates
* Computer Hostname
* Git & Github
* OSX Defaults

The following software will be installed:

* | Homebrew
* | Formulas:
  | git, hub, bash-completion, ssh-copy-id, wget, dnsmasq, nginx, cowsay, 
  | python, mysql, postgres, postgis and their requirements
* | PIP installs: virtualenv, virtualenvwrapper, numpy
* | oh-my-zsh

Additionally ``~/.profile`` and ``~/.zshrc`` will be setup for you.


Using Bootstrap
---------------

* run ``~/.osx-bootstrap`` to autoupdate your system from time to time
* run ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/osx-bootstrap-nuke.sh)`` to uninstall osx-bootstrap (not working yet)
