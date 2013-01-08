puppet-fcrepo
=================

A [puppet module](http://docs.puppetlabs.com) to setup [fedora-commons](http://www.fedora-commons.org/) on Ubuntu

Setup vagrant
==============

Follow instructions to download and install vagrant from http://vagrantup.com/v1/docs/getting-started/index.html

Usage
=====
  Define fedora installation path
      $fedora_home_path = "/usr/share/fedora-3.6.2/" 
  
  Set the source url for the installer, this can be a local path or a url to the installer.

      class {"fcrepo":
        source_url => "/vagrant/fcrepo-installer-3.6.2.jar",
        home_dir => $fedora_home_path,
        require => Exec["apt-get update"],
      }

  A copy of install properties is kept in the templates files, customise this for your own install.

TODO
====
 * Restructure installation folder to be more consistent with file system hierarchy guidelines
 * Move config in install.properties into parameters
 * Share with fedora peeps! 
