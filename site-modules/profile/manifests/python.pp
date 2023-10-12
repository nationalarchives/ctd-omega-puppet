class profile::python (String $version = '3.12.0', String $pyenv_root = '/home/ec2-user/.pyenv') {

  exec { 'install-pyenv':
    command     => 'curl https://pyenv.run | bash',
    path        => '/usr/bin',
    environment => ["PYENV_ROOT=${pyenv_root}"],
    creates     => "${pyenv_root}/bin/pyenv",
    user        => 'ec2-user',
    require     => Package['curl'],
  }

  $bashrc_pyenv_lines = [
    '# pyenv',
    'export PYENV_ROOT="$HOME/.pyenv"',
    'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"',
    'eval "$(pyenv init -)"',
  ]

  each($bashrc_pyenv_lines) |$line| {
    file_line { "ensure '${line}' in /home/ec2-user/.bashrc":
      path      => '/home/ec2-user/.bashrc',
      line      => $line,
      subscribe => Exec['install-pyenv'],
    }
  }

  exec { "pyenv-install-python-${version}":
    command     => "${pyenv_root}/bin/pyenv install ${version}",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    creates     => "${pyenv_root}/versions/${version}",
    user        => 'ec2-user',
    require     => [
      Exec['install-pyenv'],
      Package['bzip2-devel'],
      Package['libffi-devel'],
      Package['ncurses-devel'],
      Package['openssl11-devel'],
      Package['readline-devel'],
      Package['sqlite-devel'],
      Package['xz-devel'],
      Package['zlib-devel'],
    ],
  }

  exec { "pyenv-set-global-python-${version}":
    command     => "${pyenv_root}/bin/pyenv global ${version}",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    user        => 'ec2-user',
    subscribe   => Exec["pyenv-install-python-${version}"],
  }

  # Packages needed for building Python when calling 'pyenv install'
  package { 'bzip2-devel':
    ensure => installed,
  }

  package { 'libffi-devel':
    ensure => installed,
  }

  package { 'ncurses-devel':
    ensure => installed,
  }

  package { 'openssl11-devel':
    ensure => installed,
  }

  package { 'readline-devel':
    ensure => installed,
  }

  package { 'sqlite-devel':
    ensure => installed,
  }

  package { 'xz-devel':
    ensure => installed,
  }

  package { 'zlib-devel':
    ensure => installed,
  }
}
