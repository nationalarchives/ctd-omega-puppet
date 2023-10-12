class profile::docker {
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

  file { '/home/ec2-user/.docker':
    ensure => directory,
    owner  => 'ec2-user',
    group  => 'ec2-user',
  }

  file { '/home/ec2-user/.docker/cli-plugins':
    ensure  => directory,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    require => File['/home/ec2-user/.docker'],
  }

  exec { 'install-docker-compose-plugin':
    command => 'curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o /home/ec2-user/.docker/cli-plugins/docker-compose',
    path    => '/usr/bin',
    user    => 'ec2-user',
    creates => '/home/ec2-user/.docker/cli-plugins/docker-compose',
    require => [
      Package['docker'],
      File['/home/ec2-user/.docker/cli-plugins'],
      Package['curl']
    ],
  }

  file { '/home/ec2-user/.docker/cli-plugins/docker-compose':
    ensure    => file,
    owner     => 'ec2-user',
    group     => 'ec2-user',
    mode      => '0750',
    subscribe => Exec['install-docker-compose-plugin'],
  }
}
