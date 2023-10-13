class profile::ms_sql_server (String $sa_password) {
  include profile::firewall
  include yum

  exec { 'add-mssql-server-repo':
    command => 'yum-config-manager --add-repo https://packages.microsoft.com/config/rhel/7/mssql-server-2019.repo',
    path    => '/usr/bin',
    creates => '/etc/yum.repos.d/mssql-server-2019.repo',
  }

  package { 'mssql-server':
    ensure  => installed,
    require => Exec['add-mssql-server-repo'],
  }

  group { 'mssql':
    ensure          => present,
    auth_membership => true,
    system          => true,
  }

  user { 'mssql':
    ensure     => present,
    gid        => 'mssql',
    comment    => 'Service User Account for Microsoft SQL Server',
    system     => true,
    managehome => false,
    home       => '/var/opt/mssql',
    shell      => '/bin/bash',
    require    => Group['mssql'],
  }

  file { '/opt/mssql':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => [
      User['mssql'],
      Package['mssql-server']
    ],
  }

  file { '/var/opt/mssql':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => [
      User['mssql'],
      Package['mssql-server']
    ],
  }

  file { '/mssql':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => [
      User['mssql'],
      Package['mssql-server']
    ],
  }

  file { '/mssql/data':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => File['/mssql'],
  }

  file { '/mssql/log':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => File['/mssql'],
  }

  file { '/mssql/backup':
    ensure  => directory,
    replace => false,
    owner   => 'mssql',
    group   => 'mssql',
    mode    => '0750',
    require => File['/mssql'],
  }

  exec { 'configure-mssql-server':
    environment => [
      'MSSQL_PID=Developer',
      'ACCEPT_EULA=Y',
      "MSSQL_SA_PASSWORD=${sa_password}",
      'MSSQL_DATA_DIR=/mssql/data',
      'MSSQL_LOG_DIR=/mssql/log',
      'MSSQL_BACKUP_DIR=/mssql/backup',
    ],
    command     => '/opt/mssql/bin/mssql-conf -n setup',
    creates     => '/var/opt/mssql/.system/instance_id',
    require     => [
      Package['mssql-server'],
      File['/opt/mssql'],
      File['/var/opt/mssql'],
      File['/mssql/data'],
      File['/mssql/log'],
      File['/mssql/backup'],
      User['mssql']
    ],
  }

  service { 'mssql-server':
    ensure  => running,
    name    => 'mssql-server',
    enable  => true,
    require => [
      Package['mssql-server'],
      Exec['configure-mssql-server']
    ],
  }

  exec { 'download-microsoft-prod.repo':
    command => 'curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /tmp/microsoft-prod.repo',
    path    => '/usr/bin',
    creates => '/tmp/microsoft-prod.repo',
    unless  => 'test -f /etc/yum.repos.d/microsoft-prod.repo',
  }

  exec { 'add-microsoft-prod-repo':
    command => 'yum-config-manager --add-repo /tmp/microsoft-prod.repo',
    path    => '/usr/bin',
    creates => '/etc/yum.repos.d/microsoft-prod.repo',
    require => Exec['download-microsoft-prod.repo'],
  }

  exec { 'install-mssql-tools' :
    command     => '/usr/bin/yum -y install mssql-tools',
    environment => 'ACCEPT_EULA=Y',
    unless      => '/usr/bin/yum list installed mssql-tools',
    require     => Exec['add-microsoft-prod-repo'],
  }

  file { '/etc/profile.d/append-mssql-tools-path.sh':
    content => "export PATH=\"\${PATH}:/opt/mssql-tools/bin\"",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['install-mssql-tools'],
  }

  ufw::allow { 'tsql':
    port      => '1433',
    interface => 'eth0',
    require   => [
      Package['mssql-server'],
      Exec['configure-mssql-server']
    ],
  }
}
