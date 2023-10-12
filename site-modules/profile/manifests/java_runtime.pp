class profile::java_runtime {
  package { 'java-11-amazon-corretto':
    ensure => installed,
  }

  exec { 'java-11-as-default':
    command => "/usr/sbin/alternatives --set java /usr/lib/jvm/java-11-amazon-corretto.${$facts['os']['hardware']}/bin/java",
    user    => 'root',
    require => Package['java-11-amazon-corretto'],
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
    ],
  }

  file { '/etc/profile.d/set-java-home.sh':
    content => 'export JAVA_HOME=/usr/lib/jvm/java',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/usr/lib/jvm/java'],
  }
}