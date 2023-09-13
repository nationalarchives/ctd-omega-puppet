class profile::sublime_x {
  include profile::x_desktop
  include yum

  yum::gpgkey { '/etc/pki/rpm-gpg/sublimehq-rpm-pub.gpg':
    ensure => present,
    source => 'https://download.sublimetext.com/sublimehq-rpm-pub.gpg',
  }

  exec { 'add-sublime-repo':
    command => 'yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo',
    path    => '/usr/bin',
    creates => '/etc/yum.repos.d/sublime-text.repo',
    require => Yum::Gpgkey['/etc/pki/rpm-gpg/sublimehq-rpm-pub.gpg'],
  }

  package { 'sublime-text':
    ensure  => installed,
    require => Exec['add-sublime-repo'],
  }

  file { '/home/ec2-user/Desktop/Sublime.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Sublime Text
Exec=/opt/sublime_text/sublime_text
Icon=/opt/sublime_text/Icon/256x256/sublime-text.png
Terminal=false
StartupNotify=false
GenericName=Sublime Text Editor
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      Package['sublime-text']
    ],
  }
}
