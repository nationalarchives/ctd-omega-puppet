class profile::xml_x_development {
  include profile::x_desktop

  $oxygen_version = '25.1'

  file { "/opt/oxygen-${oxygen_version}":
    ensure  => directory,
    replace => false,
  }

  exec { 'install-oxygen':
    command => "curl https://mirror.oxygenxml.com/InstData/Editor/All/oxygen.tar.gz | tar zxv -C /opt/oxygen-${oxygen_version} --strip-components=1",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/oxygen-${oxygen_version}/oxygen.sh",
    require => [
      File["/opt/oxygen-${oxygen_version}"],
      Package['curl']
    ],
  }

  file { '/opt/oxygen':
    ensure  => link,
    target  => "/opt/oxygen-${oxygen_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => File["/opt/oxygen-${oxygen_version}"],
  }

  file { '/home/ec2-user/Desktop/Oxygen.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Oxygen XML Editor
Exec=/opt/oxygen/oxygen.sh
Icon=/opt/oxygen/Oxygen128.png
Terminal=false
StartupNotify=false
GenericName=Oxygen XML Editor
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      File['/opt/oxygen']
    ],
  }
}
