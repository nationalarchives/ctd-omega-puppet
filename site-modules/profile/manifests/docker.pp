class profile::docker (String $pyenv_python_version = '3.12.0', String $pyenv_root = '/home/ec2-user/.pyenv') {
  require profile::python

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

  # TODO(AR) not sure which pip3 this will find so just use the explicit pip command below
  # package { 'docker-compose':
  #   ensure   => installed,
  #   provider => 'pip3',
  #   require  => Package['python3-pip'],
  # }

  exec { 'pip-install-docker-compose':
    command     => "${pyenv_root}/shims/pip install docker-compose",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "${pyenv_root}/shims/pip show docker-compose",
    user        => 'ec2-user',
    require     => Exec["pyenv-install-python-${pyenv_python_version}"],
  }
}
