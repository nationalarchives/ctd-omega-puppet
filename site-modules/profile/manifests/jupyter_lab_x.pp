class profile::jupyter_lab_x (String $pyenv_python_version = '3.12.0', String $pyenv_root = '/home/ec2-user/.pyenv', String $user = 'ec2-user') {
  include profile::x_desktop
  include yum
  require profile::python

  exec { 'pip-install-jupyterlab':
    command     => "${pyenv_root}/shims/pip install jupyterlab",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "${pyenv_root}/shims/pip show jupyterlab",
    user        => $user,
    require     => Exec["pyenv-install-python-${pyenv_python_version}"],
  }

  file { "/home/${user}/Desktop/JupyterLab.desktop":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=JupyterLab
Exec=/home/${user}/.pyenv/shims/jupyter lab
Icon=/home/${user}/.pyenv/versions/${pyenv_python_version}/share/icons/hicolor/scalable/apps/jupyterlab.svg
Terminal=true
StartupNotify=false
GenericName=JupyterLab
",
    require => [
      Yum::Group['Xfce'],
      File["/home/${user}/Desktop"],
      Exec['pip-install-jupyterlab']
    ],
  }
}
