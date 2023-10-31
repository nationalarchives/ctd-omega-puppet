class role::www_omg_host {
  file { '/var/www':
    ensure  => directory,
    replace => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/var/www/www.omg.catalogue.nationalarchives.gov.uk':
    ensure  => directory,
    replace => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/var/www'],
  }

  package { 'git':
    ensure  => installed,
  }

  vcsrepo { '/var/www/www.omg.catalogue.nationalarchives.gov.uk':
    ensure             => latest,
    provider           => git,
    source             => 'https://github.com/nationalarchives/ctd-omega-www-omg.git',
    revision           => 'main',
    keep_local_changes => false,
    owner              => 'root',
    group              => 'root',
    require            => [
      Package['git'],
      File['/var/www/www.omg.catalogue.nationalarchives.gov.uk']
    ],
  }
}
