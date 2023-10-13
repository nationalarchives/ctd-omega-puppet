class profile::vscode_x {
  include profile::x_desktop
  include yum

  exec { 'download-vscode.repo':
    command => 'curl https://packages.microsoft.com/yumrepos/vscode/config.repo -o /tmp/vscode.repo',
    path    => '/usr/bin',
    creates => '/tmp/vscode.repo',
    unless  => 'test -f /etc/yum.repos.d/vscode.repo',
  }

  exec { 'add-vscode-repo':
    command => 'yum-config-manager --add-repo /tmp/vscode.repo',
    path    => '/usr/bin',
    creates => '/etc/yum.repos.d/vscode.repo',
    require => Exec['download-vscode.repo'],
  }

  package { 'code':
    ensure  => installed,
    require => Exec['add-vscode-repo'],
  }

  file { '/home/ec2-user/Desktop/VSCode.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Exec=/usr/share/code/bin/code
Icon=/usr/share/code/resources/app/resources/linux/code.png
Terminal=false
StartupNotify=false
GenericName=Visual Studio Code
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      Package['code']
    ],
  }
}
