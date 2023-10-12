class profile::awscurl (String $pyenv_python_version = '3.12.0', String $pyenv_root = '/home/ec2-user/.pyenv') {
  require profile::python

  exec { 'pip-install-awscurl':
    command     => "${pyenv_root}/shims/pip install awscurl",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "${pyenv_root}/shims/pip show awscurl",
    user        => 'ec2-user',
    require     => Exec["pyenv-install-python-${pyenv_python_version}"],
  }
}
