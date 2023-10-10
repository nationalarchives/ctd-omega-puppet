class profile::scala_development {
  $sbt_version = '1.5.5'

  file { "/opt/sbt-${sbt_version}":
    ensure  => directory,
    replace => false,
  }

  exec { 'install-sbt':
    command => "curl -L https://github.com/sbt/sbt/releases/download/v${sbt_version}/sbt-${sbt_version}.tgz | tar zxv -C /opt/sbt-${sbt_version} --strip-components=1",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/sbt-${sbt_version}/bin/sbt",
    require => [
      File["/opt/sbt-${sbt_version}"],
      Package['curl']
    ],
  }

  file { '/opt/sbt':
    ensure  => link,
    target  => "/opt/sbt-${sbt_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => File["/opt/sbt-${sbt_version}"],
  }

  file { '/etc/profile.d/append-sbt-path.sh':
    content => "export SBT_HOME=/opt/sbt; export PATH=\"\${PATH}:/opt/sbt/bin\"",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/opt/sbt'],
  }
}
