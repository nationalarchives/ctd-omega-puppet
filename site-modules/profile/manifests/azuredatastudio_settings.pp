class profile::azuredatastudio_settings (String $config_base = '/home/ec2-user/.config/azuredatastudio', String $settings_filename = 'azuredatastudio.dev-workstation.settings.json', String $owner = 'ec2-user', String $group = 'ec2-user', Array $require = [File['/home/ec2-user']]) {
  include profile::base

  file { $config_base:
    ensure  => directory,
    replace => false,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
    require => $require,
  }

  file { "${config_base}/User":
    ensure  => directory,
    replace => false,
    owner   => $owner,
    group   => $group,
    mode    => '0750',
    require => File[$config_base],
  }

  file { "${config_base}/User/settings.json":
    ensure  => file,
    replace => false,
    owner   => $owner,
    group   => $group,
    mode    => '0660',
    source  => "puppet:///modules/${module_name}/${settings_filename}",
    require => File["${config_base}/User"],
  }
}
