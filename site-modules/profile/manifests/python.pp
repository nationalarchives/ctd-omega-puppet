class profile::python {
  package { 'python3':
    ensure => installed,
  }

  package { 'python3-pip':
    ensure  => installed,
    require => Package['python3'],
  }
}
