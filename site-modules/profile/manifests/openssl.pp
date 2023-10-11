class profile::openssl {
  # ensure OpenSSL is up to date
  class { 'openssl':
    package_ensure         => latest,
    ca_certificates_ensure => latest,
  }

  $openssl_dhparam = lookup( {
      'name'       => 'custom_openssl::dhparam',
      'merge'      => {
        'strategy' => 'deep',
      },
      default_value => {},
  })

  if (!empty($openssl_dhparam)) {
    # Create the directory(s) for the params if they do not exist
    dirtree { "${dirname($openssl_dhparam['path'])}":
      ensure  => present,
      parents => true,
    }

    # create the params
    openssl::dhparam { "${$openssl_dhparam['path']}":
      size => $openssl_dhparam['size'],
    }
  }

  $openssl_certificates = lookup( {
      'name'       => 'custom_openssl::certificates',
      'merge'      => {
        'strategy' => 'deep',
      },
      default_value => {},
  })

  if (!empty($openssl_certificates)) and (!empty($openssl_certificates['x509_certs'])) {
    # Create the directory(s) for the certificate(s) if they do not exist
    each($openssl_certificates['x509_certs']) |$key, $cert_config| {
      dirtree { "${dirname($cert_config['key'])}":
        ensure  => present,
        parents => true,
      }
    }

    # create the certificate(s)
    class { 'openssl::certificates':
      x509_certs => $openssl_certificates['x509_certs'],
    }
  }
}
