class profile::epel {
  include profile::amazon_linux
  profile::amazon_linux::amazon_linux_extras { 'epel':
    ensure => 'present',
  }
}
