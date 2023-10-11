# The base profile should include component modules that will be on all nodes
class profile::base {
  include profile::epel
  include profile::ssh_server
  include profile::gb_locale
  include profile::openssl

  # schedule security updates
  class { 'yum_cron':
    apply_updates => true,
    update_cmd    => security,
  }

  # ensure that chrony service is running
  service { 'chronyd':
    ensure => running,
    enable => true,
  }

  # ensure ec2-user home remains private
  file { '/home/ec2-user':
    ensure  => directory,
    replace => false,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0700',
  }

  # install additional packages
  $additional_packages = ['curl', 'htop', 'screen']
  package { $additional_packages:
    ensure => 'installed',
  }
}
