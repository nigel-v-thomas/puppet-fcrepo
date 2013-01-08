class fcrepo::install (
  $source_url, 
  $home_dir = $fcrepo::params::home_dir, 
  $package = $fcrepo::params::package,
  $fedora_user = $fcrepo::params::fedora_user,
  $fedora_user_home_dir = $fcrepo::params::fedora_user_home_dir,
  $java_home = $fcrepo::params::java_home,
  ) inherits fcrepo::params {
  $tmp_dir = "/var/tmp"
  
  # ensure home dir is setup and installed
  exec { "create_fcrepo_home_dir":
    command => "echo 'creating ${home_dir}' && mkdir -p ${home_dir}",
    path => ["/bin", "/usr/bin", "/usr/sbin"],
    creates => $home_dir
  }
   
  file {$home_dir:
    path    => $home_dir,
    ensure  => directory,
    owner   => $fedora_user,
    group   => $fedora_user,
    mode    => 0644,
    require => [Exec["create_fcrepo_home_dir"]],
  }

  file { "${fedora_user_home_dir}":
    ensure => directory,
    owner => "$fedora_user",
  }

  user {"$fedora_user":
    ensure => present,
    home => "${fedora_user_home_dir}",
    before => File["$fedora_user_home_dir"],
    name => "$fedora_user",
    system => true,
    shell => "/bin/bash",
  }
  
  # Configure environment variables
  file {"${fedora_user_home_dir}/.pam_environment":
    ensure => file,
    content => template("fcrepo/.pam_environment.erb"),
    owner   => $fedora_user,
    mode    => 0755,
  }

  # state information should go here like file system db etc
  file {"/var/lib/fcrepo":
    ensure  => directory,
    owner   => $fedora_user,
    mode    => 0644,
    require => File[$home_dir],
  }

  # if source url is a valid url, download solr
  if $source_url =~ /^http.*/ {
    $source = "${tmp_dir}/${package}.tgz"

    exec { "download-mcf":
      command => "wget $source_url",
      creates => "$source",
      cwd => "$tmp_dir",
      path => ["/bin", "/usr/bin", "/usr/sbin"],
      require => File[$mcf_synchdirectory],
      before => Exec["unpack-fcrepo"],
    }
    
  } else {
    # assumes is a path.. 
    $source = $source_url
  }
  
  $tmp_install_dir = "$tmp_dir/fcrepo_installation_temp"
 
  file { "${tmp_install_dir}":
    ensure => directory,
    owner => "$fedora_user",
  }
 
  file { "${tmp_install_dir}/fcrepo-installer.jar":
    ensure => file,
    owner => "$fedora_user",
    mode => 0755,
    source => $source_url,
    require => [File["${tmp_install_dir}"],File[$home_dir]],
  }

  file { "${tmp_install_dir}/install.properties":
    ensure => file,
    owner => "$fedora_user",
    content => template("fcrepo/install.properties.erb"),
    require => File["${tmp_install_dir}/fcrepo-installer.jar"]
  }

  exec {"java -jar fcrepo-installer.jar install.properties":
    path => ["/bin", "/usr/bin", "/usr/sbin"],
    cwd => $tmp_install_dir,
    creates => "${home_dir}/install",
    require => File["${tmp_install_dir}/install.properties"],
    user => $fedora_user,
  } 
}
