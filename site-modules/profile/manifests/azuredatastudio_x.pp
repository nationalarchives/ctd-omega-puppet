class profile::azuredatastudio_x {
  include profile::x_desktop
  include yum

  yum::install { 'azuredatastudio':
    ensure => present,
    source => 'https://sqlopsbuilds.azureedge.net/stable/65fb22cc7c36db9c53af1ed2fdbdf48f66c682be/azuredatastudio-linux-1.31.1.rpm',
  }

  file { '/home/ec2-user/Desktop/AzureDataStudio.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Azure Data Studio
Exec=/usr/bin/azuredatastudio
Icon=/usr/share/azuredatastudio/resources/app/resources/linux/code.png
Terminal=false
StartupNotify=false
GenericName=Microsoft Azure Data Studio
",
    require => [
      Yum::Group['Xfce'],
      Yum::Install['azuredatastudio'],
      File['/home/ec2-user/Desktop']
    ],
  }
}
