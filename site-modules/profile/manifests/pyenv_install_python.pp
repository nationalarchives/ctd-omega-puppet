# Uses pyenv to install one or more versions of Python
# and optionally set a default version of Python.
#
# @param version one or more Python versions
# @param default_version an optional default version of Python to set
# @param pyenv_root the PYENV_ROOT folder
# @param user the user account to use for these actions
#
# @author Adam Retter
#
class profile::pyenv_install_python (
  Array[String, 1] $version = ['3.12.0'],
  Optional[String] $default_version,
  String $pyenv_root = '/home/ec2-user/.pyenv',
  String $user = 'ec2-user'
) {
  include profile::pyenv

  each($version) |$v| {
    exec { "pyenv-install-python-${v}":
      command     => "${pyenv_root}/bin/pyenv install ${v}",
      environment => ["PYENV_ROOT=${pyenv_root}"],
      creates     => "${pyenv_root}/versions/${v}",
      user        => $user,
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
  }

  if $default_version != undef {
    exec { "pyenv-set-global-python-${default_version}":
      command     => "${pyenv_root}/bin/pyenv global ${default_version}",
      environment => ["PYENV_ROOT=${pyenv_root}"],
      user        => $user,
      subscribe   => Exec["pyenv-install-python-${default_version}"],
    }
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
