class profile::nginx {
  include yum
  include profile::firewall

  ### START Version of nginx offered by Amazon Linux is outdated, so use the nginx repo
  yum::gpgkey { '/etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX':
    ensure => present,
    source => 'https://nginx.org/keys/nginx_signing.key',
  }

  file { '/etc/yum.repos.d/nginx.repo':
    ensure  => file,
    content => "[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX
module_hotfixes=true
",
    require => Yum::Gpgkey['/etc/pki/rpm-gpg/RPM-GPG-KEY-NGINX'],
  }

  class { 'nginx':
    require => File['/etc/yum.repos.d/nginx.repo'],
  }
  ### END Version of nginx offered by Amazon Linux is outdated, so use the nginx repo

  ufw::allow { 'http':
    port      => '80',
    interface => 'eth0',
  }

  ufw::allow { 'https':
    port      => '443',
    interface => 'eth0',
  }
}
