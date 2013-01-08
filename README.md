puppet-fcrepo
=================

A [puppet module](http://docs.puppetlabs.com) to setup [fedora-commons](http://www.fedora-commons.org/), tested on Ubuntu 12.04

Features
========
 * Installs fedora based on install.properties (non interactive/silent install)
 * Install as a particular user, with option to create the required user (default creates a user fedora36 and installs as this user)
 * Includes a init.d script to run fedora as a service - launches fedora automatically on server start

Setup vagrant
==============

Follow instructions to download and install vagrant from http://vagrantup.com/v1/docs/getting-started/index.html
Configure vagrant to use puppet..
Add this as to the modules directory.

Usage
=====
  Define fedora installation path
      $fedora_home_path = "/usr/share/fedora-3.6.2/" 
  
  Set the source url for the installer, this can be a local path or a url to the installer.

  class {"fcrepo":
    source_url => "/vagrant/fcrepo-installer-3.6.2.jar",
    home_dir => $fedora_home_path,
    enable_resource_index => false,
    #create_fedora_user => false,
    #fedora_user => "root",
    #fedora_user_home_dir => "/root/",
  }

  A copy of install properties is kept in the templates files, customise this for your own install.

TODO
====
 * Restructure installation folder to be more consistent with file system hierarchy guidelines
 * Move config in install.properties into parameters
 * Share with fedora peeps! 
