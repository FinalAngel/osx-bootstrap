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
   | ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/install.sh)``

You will need to enter your **sudo password** and **github information** during the installation process.

Some scripts require additional configuration, please refere to the source code and read the comments.
You will have to take the following actions to complete the installation for the core modules:

* | Add your RSA key (``cat ~/.ssh/id_rsa.pub``) into your github.com account under ``SSH Keys``
* | The default hostname will be set to **osx-`whoami`** you can overwrite this by adding the desired hostname using:
  | ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/install.sh) my-computer``


About Bootstrap
---------------

The following configurations will be automated using the core modules:

* Disc Encryption
* Softwareupdates
* Computer Hostname
* Git & Github
* OSX Defaults

The following software will be installed using the core modules:

* | Homebrew
* | Formulas:
  | git, git-flow, hub, bash-completion, ssh-copy-id, wget, dnsmasq, nginx, cowsay, 
  | python, mysql, postgres, postgis and their requirements
* | PIP installs: virtualenv, virtualenvwrapper, numpy
* | oh-my-zsh

Additionally ``~/.profile`` and ``~/.zshrc`` will be setup for you.

You can install additional modules inside the /extras folder using the following command: `blah`
Follow additional instructions that are printed out or read the source.
Be aware that the core modules are required!


Using Bootstrap
---------------

* run ``~/.osx-bootstrap`` to update osx-bootstrap and your system


Uninstalling Bootstrap
----------------------

* run ``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/extras/nuke.sh)`` to uninstall osx-bootstrap core modules
