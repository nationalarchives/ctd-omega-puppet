class role::web_application_server {
  include profile::base
  include profile::firewall
  include profile::java_runtime

  ufw::allow { 'Play https from vpc_private_subnet_dev_general':
    port      => '9443',
    from      => '10.129.202.0/24',  # TODO(AR) make this injectable from Terraform via Facter
    interface => 'eth0',
  }

  ufw::allow { 'Play https from web-proxy-1':
    port      => '9443',
    from      => '10.129.199.4',  # TODO(AR) make this injectable from Terraform via Facter
    interface => 'eth0',
  }

  user { 'ctd-omega-editorial-frontend':
    ensure     => present,
    comment    => 'Service User Account for the ctd-omega-editorial-frontend application',
    system     => true,
    membership => inclusive,
    managehome => false,
    home       => '/nonexistent',
    shell      => '/sbin/nologin',
  }
}
