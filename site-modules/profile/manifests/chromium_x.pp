class profile::chromium_x {
  include profile::x_desktop
  include profile::epel

  package { 'chromium':
    ensure  => installed,
    require => [
      Class['profile::epel']
    ],
  }

  file { '/home/ec2-user/Desktop/Chromium.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Chromium
Exec=/usr/bin/chromium-browser
Icon=/usr/share/icons/hicolor/256x256/apps/chromium-browser.png
Terminal=false
StartupNotify=false
GenericName=Chromium Web Browser
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      Package['chromium']
    ],
  }
}
