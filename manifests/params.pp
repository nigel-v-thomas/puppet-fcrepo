# This is the generic solr parameters
class fcrepo::params {
  case $operatingsystem {
    /(Ubuntu|Debian)/: {
      $source_url = "/vagrant/fcrepo-installer-3.6.2.jar"
      $home_dir = "/usr/share/fedora-3.6.2/"
      $package = "fcrepo-installer-3.6.2"
      $fedora_user_home_dir = "/home/fedora36"
      $fedora_user = "fedora36"
    }
    default: {
      fail("Operating system $operatingsystem is not supported by the tomcat module")
    }
  }
}
