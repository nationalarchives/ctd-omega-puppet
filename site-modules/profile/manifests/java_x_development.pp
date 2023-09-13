class profile::java_x_development {
  include profile::x_desktop

  $intellij_idea_version = '2023.2.1'
  $eclipse_version = '2023-06'

  exec { 'install-intellij-ce':
    command => "curl -L https://download.jetbrains.com/idea/ideaIC-${intellij_idea_version}.tar.gz | tar zxv -C /opt",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/idea-IC-${intellij_idea_version}",
    require => Package['curl'],
  }

  file { '/opt/idea-IC':
    ensure  => link,
    target  => "/opt/idea-IC-${intellij_idea_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-intellij-ce'],
  }

  file { '/home/ec2-user/Desktop/IntelliJ.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA CE
Exec=/opt/idea-IC/bin/idea.sh
Icon=/opt/idea-IC/bin/idea.svg
Terminal=false
StartupNotify=false
GenericName=IntelliJ IDEA CE
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      File['/opt/idea-IC']
    ],
  }

  exec { 'install-eclipse':
    command => "curl https://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/${eclipse_version}/R/eclipse-java-${eclipse_version}-R-linux-gtk-x86_64.tar.gz | tar zxv -C /opt && mv /opt/eclipse /opt/eclipse-${eclipse_version}",
    path    => '/usr/bin',
    user    => 'root',
    creates => "/opt/eclipse-${eclipse_version}",
    require => Package['curl'],
  }

  file { '/opt/eclipse':
    ensure  => link,
    target  => "/opt/eclipse-${eclipse_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-eclipse'],
  }

  file { '/home/ec2-user/Desktop/Eclipse.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse
Exec=/opt/eclipse/eclipse
Icon=/opt/eclipse/icon.xpm
Terminal=false
StartupNotify=false
GenericName=Eclipse IDE
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      File['/opt/eclipse']
    ],
  }
}
