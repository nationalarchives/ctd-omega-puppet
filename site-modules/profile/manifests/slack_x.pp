class profile::slack_x {
  include profile::x_desktop
  include yum

  $slack_version = '4.33.90'

  yum::install { 'slack':
    ensure => present,
    source => 'https://downloads.slack-edge.com/releases/linux/4.33.90/prod/x64/slack-4.33.90-0.1.el8.x86_64.rpm',
  }

  file { '/home/ec2-user/Desktop/Slack.desktop':
    ensure  => file,
    owner   => 'ec2-user',
    group   => 'ec2-user',
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=Slack
Exec=/usr/bin/slack
Icon=/usr/lib/slack/resources/app.asar.unpacked/dist/resources/slack-taskbar-rest.ico
Terminal=false
StartupNotify=false
GenericName=Slack
",
    require => [
      Yum::Group['Xfce'],
      File['/home/ec2-user/Desktop'],
      Yum::Install['slack']
    ],
  }
}
