# Installs pyenv and pyenv-virualenv
#
# @param pyenv_root the PYENV_ROOT folder
# @param user the user account to use for these actions
#
# @author Adam Retter
#
class profile::pyenv (
  String $pyenv_root = '/home/ec2-user/.pyenv',
  String $user = 'ec2-user'
) {
  exec { 'install-pyenv':
    command     => 'curl https://pyenv.run | bash',
    path        => '/usr/bin',
    environment => ["PYENV_ROOT=${pyenv_root}"],
    creates     => "${pyenv_root}/bin/pyenv",
    user        => $user,
    require     => Package['curl'],
  }

  $bashrc_pyenv_lines = [
    '# pyenv',
    'export PYENV_ROOT="$HOME/.pyenv"',
    'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"',
    'eval "$(pyenv init -)"',
  ]

  each($bashrc_pyenv_lines) |$line| {
    file_line { "ensure '${line}' in /home/${user}/.bashrc":
      path      => "/home/${user}/.bashrc",
      line      => $line,
      subscribe => Exec['install-pyenv'],
    }
  }
}
