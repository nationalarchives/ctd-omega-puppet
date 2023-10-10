class profile::ssh_server {
  package { 'openssh':
    ensure => installed,
  }

  class { 'ssh':
    storeconfigs_enabled => false,
    validate_sshd_file   => true,
    server_options       => {
      'Port'                            => [22],
      'HostKey'                         => [
        '/etc/ssh/ssh_host_rsa_key',
        '/etc/ssh/ssh_host_ecdsa_key',
        '/etc/ssh/ssh_host_ed25519_key',
      ],
      'SyslogFacility'                  => 'AUTHPRIV',
      'AuthorizedKeysFile'              => '.ssh/authorized_keys',
      'PermitRootLogin'                 => 'no',
      'PasswordAuthentication'          => 'no',
      'ChallengeResponseAuthentication' => 'no',
      'GSSAPIAuthentication'            => 'yes',
      'GSSAPICleanupCredentials'        => 'yes',
      'UsePAM'                          => 'yes',
      'X11Forwarding'                   => 'yes',
      'PrintMotd'                       => 'yes',
      'AllowTcpForwarding'              => 'no',
      'AcceptEnv'                       => [
        'LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES',
        'LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT',
        'LC_IDENTIFICATION LC_ALL LANGUAGE',
        'XMODIFIERS',
      ],
    },
    users_client_options => {
      'ec2-user' => {
        options => {
          'HashKnownHosts' => 'yes',
        },
      },
    },
    subscribe            => Package['openssh'],
  }

  ssh_authorized_key { 'aretter@hollowcore.local':
    ensure => present,
    user   => 'ec2-user',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDHvJ21M2Jfw75K82bEdZIhL9t7N8kUuXOPxKWFs7o6Z+42UGH47lmQrk95OJdhLxlp2paGFng++mMLV1Xf7uLjTUE8lJHJv/TSzC81Q5NSfFXQTn4kpr5BRKgTnXPNYTHcsueeUr6auZDThVG3mU62AvieFeI5MJOE7FlAS4++u2pVG7+H4l48snlKiUDH5oXRLdJtZbED2v6byluSkj6uNThEYoHzHRxvF8Lo12NgQEMBVrHyvBWtHPpZIhCzzzsTEf9+249VqsO3NqTl7vswMhf8z2NYgGjf0w+5A3bJDIpvDRWQ+40uB1bdwqUDuiY8nGSSKwpVOby0cYZjfhjZ',
  }

  include profile::firewall

  ufw::allow { 'SSH':
    port    => '22',
  }
}
