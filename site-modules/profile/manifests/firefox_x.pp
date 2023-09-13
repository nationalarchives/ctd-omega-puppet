class profile::firefox_x {
  include profile::x_desktop

  $firefox_version = '117.0'

  exec { 'install-firefox':
    command => "curl https://download-installer.cdn.mozilla.net/pub/firefox/releases/${firefox_version}/linux-x86_64/en-GB/firefox-${firefox_version}.tar.bz2 | tar jxv -C /opt && mv /opt/firefox /opt/firefox-${firefox_version}",
    path    => '/usr/bin',
    creates => "/opt/firefox-${firefox_version}",
    require => Package['curl'],
  }

  file { '/opt/firefox':
    ensure  => link,
    target  => "/opt/firefox-${firefox_version}",
    replace => false,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-firefox'],
  }

  file { '/home/ec2-user/Desktop/Firefox.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox
Exec=/opt/firefox/firefox
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
StartupNotify=false
GenericName=Firefox Web Browser
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      File['/opt/firefox']
    ],
  }
}
