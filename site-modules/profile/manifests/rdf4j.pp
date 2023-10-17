class profile::rdf4j (String $rdf4j_version = '4.2.3') {
  include profile::tomcat

  exec { 'download-rdf4j-sdk':
    command => "curl -L https://ftp.halifax.rwth-aachen.de/eclipse/rdf4j/eclipse-rdf4j-${rdf4j_version}-sdk.zip -o /tmp/eclipse-rdf4j-${rdf4j_version}-sdk.zip",
    path    => '/usr/bin',
    creates => "/opt/eclipse-rdf4j-${rdf4j_version}",
    require => Package['curl'],
  }

  exec { 'extract-rdfj-wars':
    command => "unzip -d /opt /tmp/eclipse-rdf4j-${rdf4j_version}-sdk.zip",
    path    => '/usr/bin',
    creates => "/opt/eclipse-rdf4j-${rdf4j_version}/bin/console.sh",
    require => Exec['download-rdf4j-sdk'],
  }

  file { '/opt/rdf4j':
    ensure  => link,
    target  => "/opt/eclipse-rdf4j-${rdf4j_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['extract-rdfj-wars'],
  }

  file { '/opt/tomcat/webapps/rdf4j-server.war':
    ensure  => file,
    source  => '/opt/rdf4j/war/rdf4j-server.war',
    require => [
      File['/opt/rdf4j'],
      File['/opt/tomcat']
    ],
  }

  file { '/opt/tomcat/webapps/rdf4j-workbench.war':
    ensure  => file,
    source  => '/opt/rdf4j/war/rdf4j-workbench.war',
    require => [
      File['/opt/rdf4j'],
      File['/opt/tomcat'],
      File['/opt/tomcat/webapps/rdf4j-server.war']
    ],
  }
}
