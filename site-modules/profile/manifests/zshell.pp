class profile::zshell {
  package { 'zsh':
    ensure => installed,
  }
}
