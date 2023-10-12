class profile::base_development {
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
}
