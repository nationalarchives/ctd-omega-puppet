class profile::gb_locale {
  exec { 'set-keymap-gb':
    command => '/usr/bin/localectl set-keymap gb',
    user    => 'root',
  }

  exec { 'set-locale-en-gb-utf8':
    command => '/usr/bin/localectl set-locale LANG=en_GB.utf8',
    user    => 'root',
  }

  exec { 'set-timezone-europe-london':
    command => '/usr/bin/timedatectl set-timezone Europe/London',
    user    => 'root',
  }
}
