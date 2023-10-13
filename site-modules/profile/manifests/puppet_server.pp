class profile::puppet_server {
  include profile::firewall

  # NOTE(AR) Needed by aws-sdk-secretsmanager
  package { 'oga-puppetserver':
    ensure   => 'present',
    name     => 'oga',
    provider => 'puppetserver_gem',
  }

  # NOTE(AR) Needed by hiera-aws-secretsmanager
  package { 'aws-sdk-secretsmanager-puppetserver':
    ensure   => 'present',
    name     => 'aws-sdk-secretsmanager',
    provider => 'puppetserver_gem',
    require  => Package['oga-puppetserver'],
  }

  ufw::allow { 'Puppet Server':
    port    => '8140',
  }
}
