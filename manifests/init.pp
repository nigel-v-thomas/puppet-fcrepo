# Class: fcrepo
#
# This module installs and manages fedora commons
# Module puppet-fcrepo https://github.com/nigel-v-thomas/puppet-fedora-commons.git
# Parameters:
#
# Actions:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class fcrepo (
      $source_url = $fcrepo::params::source_url,
      $home_dir = $fcrepo::params::home_dir,
      $package = $fcrepo::params::package,
      $fedora_user = $fcrepo::params::fedora_user,
      $java_home = $fcrepo::params::fedora_user
      )inherits fcrepo::params {

  package {"openjdk-6-jdk":
    ensure => present,
    before => Class["fcrepo::install"]
  }  

  class { 
    "fcrepo::install":
    source_url => $source_url,
    home_dir => $home_dir,
    package => $package,
    fedora_user => $fedora_user,
    java_home => $java_home
  }
  class {
    "fcrepo::service":
    home_dir => $home_dir,
    require => Class["fcrepo::install"]
  }  
}
