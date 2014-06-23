=============
OSX Bootstrap
=============

This is a bash script automating configuration and installation of **OSX** workstations.


Requirements
------------

#. Install a **fresh** version of OSX (10.8 or 10.9)
#. **10.9** Open a Terminal and run ``gcc`` and install the **Command Line Tools**
#. **10.8**: Install Xcode and open ``Xcode > Preferences > Downloads`` and install the **Command Line Tools**


Install Bootstrap
-----------------

#. | Open a terminal and run:
   | ``curl -L https://raw.github.com/divio/osx-bootstrap/master/install.sh | bash``

You will need to enter your **sudo password** and **github information** during the installation process.

Some scripts require additional configuration, please refere to the source code and read the comments.
You will have to take the following actions to complete the installation for the core modules:

* | Add your RSA key (``cat ~/.ssh/id_rsa.pub``) into your github.com account under ``SSH Keys``
* | The default hostname will be set to **osx-`whoami`** you can overwrite this by adding the desired hostname inside the install.sh curl.

If you are upgrading your system from Lion/Mountain Lion to **Mavericks**, OSX Bootstrap won't stay in your way. 
Just install the upgrade and run **Xcode** and check that the Command Line Tools are still installed.


Install Extras
--------------

You can install additional modules such as:

* Node.js and NPM
* Heroku
* Ruby and Ruby on Rails
* PHP

For a list of all modules consult the ``extras/`` folder. Use the same pattern as install.sh above.

Extras are not maintained within the bootstrap update process. Edit the ``.osx-bootstrap`` file within ``~/.osx-bootstrap/`` to add those dependencies. This file will not be updated automatically.


Upgrading
---------

* run ``bootstrap`` to start the osx-bootstrap auto update.
* run ``.osx-bootstrap/upgrade.sh`` to force a full update of osx-bootstrap.


Uninstalling Bootstrap
----------------------

``bash <(curl -s https://raw.github.com/divio/osx-bootstrap/master/core/nuke.sh)``


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


