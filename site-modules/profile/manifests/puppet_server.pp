class profile::puppet_server {
  include profile::firewall

  ufw::allow { 'Puppet Server':
    port    => '8140',
  }
}
