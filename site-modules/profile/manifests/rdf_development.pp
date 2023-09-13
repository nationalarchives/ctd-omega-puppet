class profile::rdf_development {
  $jena_version = '4.9.0'

  exec { 'install-jena':
    command => "curl https://archive.apache.org/dist/jena/binaries/apache-jena-${jena_version}.tar.gz | tar zxv -C /opt",
    path    => '/usr/bin',
    creates => "/opt/apache-jena-${jena_version}",
    require => Package['curl'],
  }

  file { '/opt/jena':
    ensure  => link,
    target  => "/opt/apache-jena-${jena_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-jena'],
  }

  exec { 'install-fuseki':
    command => "curl https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${jena_version}.tar.gz | tar zxv -C /opt",
    path    => '/usr/bin',
    creates => "/opt/apache-jena-fuseki-${jena_version}",
    require => Package['curl'],
  }

  file { '/opt/fuseki':
    ensure  => link,
    target  => "/opt/apache-jena-fuseki-${jena_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-fuseki'],
  }
}
