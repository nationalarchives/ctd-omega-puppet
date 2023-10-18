# Installs Python
#
# @author Adam Retter
#
class profile::python {
  include profile::pyenv
  include profile::pyenv_install_python
}
