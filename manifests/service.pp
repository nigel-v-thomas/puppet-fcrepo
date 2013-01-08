class fcrepo::service (
  $home_dir = $fcrepo::params::home_dir,
  $fedora_user = $fcrepo::params::fedora_user,
  ) inherits fcrepo::params {
  $CATALINA_HOME_DEFAULT="${home_dir}/tomcat"
 
  $fc_start_full_path = "${CATALINA_HOME_DEFAULT}/bin/startup.sh"
  $fc_stop_full_path = "${CATALINA_HOME_DEFAULT}/bin/shutdown.sh"
  $fc_base_dir = "${home_dir}/"
  $fc_initd_log_dir = "${CATALINA_HOME_DEFAULT}/logs/"  

  file { "/etc/init.d/fcrepo":
    content => template("fcrepo/fcrepo-init.d.erb"),
    owner   => $fedora_user,
    mode    => 0755,
  }
  
  service{ "fcrepo":
    ensure => running,
    require => File["/etc/init.d/fcrepo"]
  }
}
