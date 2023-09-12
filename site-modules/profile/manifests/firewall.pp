class profile::firewall {
  include ufw
  Class['profile::epel'] -> Class['ufw']
}
