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

  include profile::firewall

  ufw::allow { 'SSH':
    port    => '22',
  }
}
