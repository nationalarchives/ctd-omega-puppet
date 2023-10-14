class profile::base_development {
  include profile::base
  include profile::zshell
  include yum

  $github_cli_version = '2.34.0'

  file { '/home/ec2-user/code':
    ensure  => directory,
    replace => false,
    owner   => 'ec2-user',
    group   => 'ec2-user',
  }

  package { 'git':
    ensure  => installed,
  }

  # Github command line interface
  yum::install { 'gh':
    ensure  => present,
    source  => "https://github.com/cli/cli/releases/download/v${github_cli_version}/gh_${github_cli_version}_linux_amd64.rpm",
    require => Package['git'],
  }

  package { 'uuid':
    ensure => installed,
  }

  package { 'jq':
    ensure => installed,
  }

  # Omega AWS Scripts
  exec { 'install-omg-aws-scripts':
    command => "curl -L https://github.com/nationalarchives/ctd-omega-aws-scripts/archive/refs/tags/1.0.0.tar.gz | tar zxv -C /home/ec2-user/bin --strip-components=1 --wildcards --no-anchored '*.sh'",
    path    => '/usr/bin/',
    user    => 'ec2-user',
    creates => '/home/ec2-user/bin/omg-assume-aws-role.sh',
    require => File['/home/ec2-user/bin'],
  }
}
