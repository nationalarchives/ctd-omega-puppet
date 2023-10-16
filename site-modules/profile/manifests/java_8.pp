class profile::java_8 {
  exec { 'enable-corretto-8':
    command => 'amazon-linux-extras enable corretto8',
    path    => '/usr/bin',
  }
  -> package { 'java-1.8.0-amazon-corretto-devel':
    ensure => installed,
  }
}
