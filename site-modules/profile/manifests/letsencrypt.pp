class profile::letsencrypt {
  class { 'letsencrypt':
    package_ensure => latest,
    configure_epel => false,  # NOTE(AR) this is managed by our EPEL profile instead
    require        => Class['profile::epel'],
  }

  class { 'letsencrypt::plugin::nginx':
    manage_package => true,
    package_name   => 'python2-certbot-nginx',
  }

  # NOTE(AR) the following will be needed if we have a requirement for Wildcard certificates
  # class { 'letsencrypt::plugin::dns_route53':
  #   manage_package => true,
  #   package_name   => 'python2-certbot-dns-route53',
  #   require => Class['letsencrypt'],
  # }
}
