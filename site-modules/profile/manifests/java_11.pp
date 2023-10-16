class profile::java_11 {
  package { 'java-11-amazon-corretto':
    ensure => installed,
  }
}
