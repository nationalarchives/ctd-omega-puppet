class profile::java_development {
  $maven_version = '3.8.5'

  package { 'java-11-amazon-corretto':
    ensure => installed,
  }

  exec { 'enable-corretto-8':
    command => 'amazon-linux-extras enable corretto8',
    path    => '/usr/bin',
    require => Package['java-11-amazon-corretto'],
  }
  -> package { 'java-1.8.0-amazon-corretto-devel':
    ensure => installed,
  }

  exec { 'java-11-as-default':
    command => '/usr/sbin/alternatives --set java /usr/lib/jvm/java-11-amazon-corretto.x86_64/bin/java',
    user    => 'root',
    require => [
      Package['java-1.8.0-amazon-corretto-devel'],
      Package['java-11-amazon-corretto']
    ],
  }

  exec { 'javac-11-as-default':
    command => '/usr/sbin/alternatives --set javac /usr/lib/jvm/java-11-amazon-corretto.x86_64/bin/javac',
    user    => 'root',
    require => [
      Package['java-1.8.0-amazon-corretto-devel'],
      Package['java-11-amazon-corretto']
    ],
  }

  file { '/usr/lib/jvm/java':
    ensure  => link,
    target  => '/etc/alternatives/java_sdk',
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => [
      Package['java-11-amazon-corretto'],
      Exec['java-11-as-default'],
      Exec['javac-11-as-default']
    ],
  }

  file { '/etc/profile.d/set-java-home.sh':
    content => 'export JAVA_HOME=/usr/lib/jvm/java',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/usr/lib/jvm/java'],
  }

  # install Maven
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
    mode    => '0644',
    require => File['/opt/maven'],
  }
}
