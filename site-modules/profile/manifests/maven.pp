class profile::maven (String $maven_version = '3.8.5') {
  exec { 'install-maven':
    command => "curl -L https://archive.apache.org/dist/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz | tar zxv -C /opt",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/apache-maven-${maven_version}",
    require => Package['curl'],
  }

  file { '/opt/maven':
    ensure  => link,
    target  => "/opt/apache-maven-${maven_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-maven'],
  }

  file { '/etc/profile.d/append-maven-path.sh':
    content => "export MAVEN_HOME=/opt/maven; export PATH=\"\${PATH}:/opt/maven/bin\"",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/opt/maven'],
  }
}
