class role::development_workstation {
  include profile::base

  # Development languages/tools
  include profile::base_development
  include profile::c_development
  include profile::cpp_development
  include profile::java_development
  include profile::nodejs_development
  include profile::rdf_development
  include profile::scala_development
  
  # Language runtimes
  include profile::python
  
  # X development tools
  include profile::x_desktop
  include profile::java_x_development
  include profile::sql_x_development
  include profile::xml_x_development
  
  # X web browsers
  include profile::chromium_x
  include profile::firefox_x
  
  # X misc tools
  include profile::diffmerge_x
  include profile::slack_x
  include profile::sublime_x

  # Docker
  include profile::docker

  # Omega code repositories
  include profile::omega_code_repositories
}
