class profile::x_desktop {
  include profile::firewall
  include yum

  $cfs_zen_tweaks_version = '1.2.0'

  yum::group { 'Xfce':
    ensure  => installed,
    timeout => 300000,
  }

  package { 'xrdp':
    ensure  => installed,
    require => Yum::Group['Xfce'],
  }

  ufw::allow { 'rdp':
    port      => '3389',
    interface => 'eth0',
    require   => Package['xrdp'],
  }

  file { '/home/ec2-user/.Xclients':
    ensure  => file,
    replace => false, # this is the important property
    content => 'xfce4-session',
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0744'
  }

  file_line { 'ec2-user-xfce4-session':
    ensure  => present,
    path    => '/home/ec2-user/.Xclients',
    line    => 'xfce4-session',
    require => [
      File['/home/ec2-user/.Xclients']
    ],
  }

  service { 'xrdp':
    ensure  => running,
    name    => 'xrdp',
    enable  => true,
    require => Package['xrdp'],
  }

  # Make desktop environment more responsive
  yum::install { 'cfs-zen-tweaks':
    ensure => present,
    source => "https://github.com/igo95862/cfs-zen-tweaks/releases/download/${$cfs_zen_tweaks_version}/cfs-zen-tweaks-${$cfs_zen_tweaks_version}-Linux.rpm",
  }
  ~> service { 'set-cfs-tweaks':
    ensure => 'running',
    enable => true,
  }

  # folder for placing Desktop links to other applications in
  file { '/home/ec2-user/Desktop':
    ensure => directory,
    owner  => 'ec2-user',
    group  => 'ec2-user',
    mode   => '0760',
  }
}
