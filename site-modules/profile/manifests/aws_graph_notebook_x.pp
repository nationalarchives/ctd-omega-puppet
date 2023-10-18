# Installs AWS Graph Notebook
#
# NOTE there is an issue whereby graph-notebook won't install on Pyton 3.12.0 due to https://github.com/pypa/setuptools/issues/3935, so we install it into a pyenv-virtualenv instead
#
# @author Adam Retter
class profile::aws_graph_notebook_x (
  String $pyenv_python_version = '3.10.0',
  String $pyenv_root = '/home/ec2-user/.pyenv',
  String $virtualenv_name = 'aws-graph-notebook',
  String $user = 'ec2-user'
) {
  include profile::x_desktop
  include yum
  require profile::python

  exec { "create-pyenv-virtualenv-${virtualenv_name}":
    command     => "${pyenv_root}/bin/pyenv virtualenv 3.10.0 ${virtualenv_name}",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "/usr/bin/test -f ${pyenv_root}/versions/${virtualenv_name}/pyvenv.cfg",
    user        => $user,
    require     => Exec["pyenv-install-python-${pyenv_python_version}"],
  }

  exec { "${virtualenv_name}-virtualenv-pip-install-jupyterlab":
    command     => "${pyenv_root}/versions/${virtualenv_name}/bin/pip install 'jupyterlab>=3,<4'",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "${pyenv_root}/versions/${virtualenv_name}/bin/pip show jupyterlab",
    user        => $user,
    require     => Exec["create-pyenv-virtualenv-${virtualenv_name}"],
  }

  exec { "${virtualenv_name}-virtualenv-pip-install-graph-notebook":
    command     => "${pyenv_root}/versions/${virtualenv_name}/bin/pip install graph-notebook",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "${pyenv_root}/versions/${virtualenv_name}/bin/pip show graph-notebook",
    user        => $user,
    require     => Exec["${virtualenv_name}-virtualenv-pip-install-jupyterlab"],
  }

  exec { "${virtualenv_name}-virtualenv-install-premade-starter-notebooks":
    command     => "${pyenv_root}/versions/${virtualenv_name}/bin/python -m graph_notebook.notebooks.install --destination /home/${user}/notebook/starter",
    environment => ["PYENV_ROOT=${pyenv_root}"],
    unless      => "/usr/bin/test -f /home/${user}/notebook/starter/01-Getting-Started/01-About-the-Neptune-Notebook.ipynb",
    user        => $user,
    require     => Exec["${virtualenv_name}-virtualenv-pip-install-graph-notebook"],
  }

  file { "/home/${user}/bin/aws-graph-notebook.sh":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0750',
    content => "#!/usr/bin/env bash

export PYENV_ROOT=\"\$HOME/.pyenv\"
command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"
eval \"$(pyenv init -)\"

pyenv shell ${virtualenv_name}
python -m graph_notebook.start_jupyterlab --jupyter-dir /home/${user}/notebook/starter
",
    require => [
      File["/home/${user}/bin"],
      Exec["${virtualenv_name}-virtualenv-pip-install-graph-notebook"],
      Exec["${virtualenv_name}-virtualenv-install-premade-starter-notebooks"]
    ],
  }

  file { "/home/${user}/Desktop/AwsGraphNotebook.desktop":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0766',
    content => "[Desktop Entry]
Version=1.0
Type=Application
Name=AWS Graph Notebook
Exec=/home/${user}/bin/aws-graph-notebook.sh
Icon=/home/${user}/.pyenv/versions/${virtualenv_name}/share/icons/hicolor/scalable/apps/notebook.svg
Terminal=true
StartupNotify=false
GenericName=AWS Graph Notebook
",
    require => [
      Yum::Group['Xfce'],
      File["/home/${user}/Desktop"],
      File["/home/${user}/bin/aws-graph-notebook.sh"],
    ],
  }
}
