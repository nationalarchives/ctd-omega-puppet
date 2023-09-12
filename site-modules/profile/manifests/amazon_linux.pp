class profile::amazon_linux {
  define amazon_linux_extras(
    Enum['present'] $ensure = present,
    ) {
    $pkg = $name
    exec { "amazon-linux-extras install -y $pkg":                                                                                                                        
      unless => "amazon-linux-extras list | grep -q '${pkg}=.*enabled'",                                                                                                 
      path   => '/usr/bin',                                                                                                                                              
    }                                                                                                                                                                    
  }
}                                                                                                                                                                
