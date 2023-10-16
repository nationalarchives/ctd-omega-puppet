class profile::tomcat (String $tomcat_version = '9.0.82') {
  include profile::java_11

  group { 'tomcat':
    ensure          => present,
    members         => ['ec2-user'],
    auth_membership => false,
    system          => true,
  }

  user { 'tomcat':
    ensure     => present,
    gid        => 'tomcat',
    comment    => 'Service User Account for Apache Tomcat',
    system     => true,
    managehome => true,
    shell      => '/sbin/nologin',
    require    => Group['tomcat'],
  }

  exec { 'install-tomcat':
    command => "curl -L https://dlcdn.apache.org/tomcat/tomcat-9/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.tar.gz | tar zxv -C /opt",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/apache-tomcat-${tomcat_version}/bin/catalina.sh",
    require => [
      Package['curl'],
      Package['java-11-amazon-corretto']
    ],
  }

  file { "/opt/apache-tomcat-${tomcat_version}/conf/tomcat-users.xml":
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    content => '<tomcat-users xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd" version="1.0">
	<role rolename="admin"/>
	<user username="admin" password="password" roles="admin,admin-gui,admin-script,manager-gui,manager-script,manager-jmx,manager-status"/>
</tomcat-users>',
    require => [
      Exec['install-tomcat']
    ],
  }

  file { "/opt/apache-tomcat-${tomcat_version}":
    ensure  => directory,
    replace => false,
    owner   => 'tomcat',
    group   => 'tomcat',
    recurse => 'true',
    require => [
      User['tomcat'],
      Exec['install-tomcat'],
      File["/opt/apache-tomcat-${tomcat_version}/conf/tomcat-users.xml"]
    ],
  }

  file { '/opt/tomcat':
    ensure  => link,
    target  => "/opt/apache-tomcat-${tomcat_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => File["/opt/apache-tomcat-${tomcat_version}"],
  }

  systemd::manage_unit { 'tomcat.service':
    enable        => true,
    active        => true,
    unit_entry    => {
      'Description' => 'Apache Tomcat Web Application Server',
    },
    service_entry => {
      'User'      => 'tomcat',
      'Group'     => 'tomcat',
      'ExecStart' => '/opt/tomcat/bin/catalina.sh run',
    },
    install_entry => {
      'WantedBy' => 'multi-user.target',
    },
    require       => [
      User['tomcat'],
      Group['tomcat'],
      Exec['install-tomcat'],
      File["/opt/apache-tomcat-${tomcat_version}/conf/tomcat-users.xml"],
      File['/opt/tomcat'],
    ],
  }
}
