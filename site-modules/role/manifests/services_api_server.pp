class role::services_api_server {
  include profile::base
  include profile::firewall
  include profile::java_runtime

  user { 'ctd-omega-services-api':
    ensure     => present,
    comment    => 'Service User Account for the ctd-omega-services-api application',
    system     => true,
    membership => inclusive,
    managehome => false,
    home       => '/nonexistent',
    shell      => '/sbin/nologin',
  }
}
