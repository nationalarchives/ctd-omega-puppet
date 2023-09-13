class profile::docker {
  include profile::python

  package { 'docker':
    ensure => installed,
  }

  group { 'docker':
    ensure          => present,
    auth_membership => false,
    members         => ['ec2-user'],
    require         => [
      Package['docker']
    ],
  }

  service { 'docker':
    ensure  => running,
    name    => 'docker',
    enable  => true,
    require => [
      Package['docker'],
      Group['docker']
    ],
  }

  package { 'docker-compose':
    ensure   => installed,
    provider => 'pip3',
    require  => Package['python3-pip'],
  }
}
