class profile::nodejs_development {

  $nodejs_version = '16.18.1'

  class { 'nvm':
    user         => 'ec2-user',
    install_node => "${nodejs_version}",
  }

  exec { 'corepack-enable':
    command => 'corepack enable',
    path    => "/home/ec2-user/.nvm/versions/node/v${nodejs_version}/bin",
    user    => 'ec2-user',
    require => Class['nvm'],
  }

  exec { 'corepack-prepare-yarn':
    command => 'corepack prepare yarn@stable --activate',
    path    => "/home/ec2-user/.nvm/versions/node/v${nodejs_version}/bin",
    user    => 'ec2-user',
    require => Exec['corepack-enable'],
  }
}
