# The base profile should include component modules that will be on all nodes
class profile::base {
  include profile::epel
  include profile::ssh_server

  class { 'yum_cron':
    apply_updates => true,
    update_cmd    => security,
  }

  package { 'htop':
    ensure => 'installed',
  }
  package { 'curl':
    ensure => 'installed',
  }
}
