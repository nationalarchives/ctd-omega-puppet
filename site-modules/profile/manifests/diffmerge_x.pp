class profile::diffmerge_x {
  include profile::x_desktop
  include yum

  yum::install { 'diffmerge':
    ensure  => present,
    source  => 'https://download.sourcegear.com/DiffMerge/4.2.0/diffmerge-4.2.0.697.stable-1.x86_64.rpm',
    require => Yum::Group['Xfce'],
  }

  file { '/home/ec2-user/Desktop/diffmerge.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    source  => '/usr/share/applications/sourcegear.com-diffmerge.desktop',
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      Yum::Install['diffmerge']
    ],
  }
}
