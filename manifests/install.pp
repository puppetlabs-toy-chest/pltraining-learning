class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'

  # Put examples in place -- we should have some way to automatically get the
  # most recent from the puppet docs source, where they'll be in
  # source/learning/files/examples.
  file {'/root/examples':
    ensure  => directory,
    source  => "puppet:///modules/${module_name}/examples",
    recurse => true,
  }

  file {[ "$prod_module_path", 
          "${prod_module_path}/cowsayings",
          "${prod_module_path}/cowsayings/manifests",
          "${prod_module_path}/cowsayings/tests",
        ]: 
    ensure => directory,
    require  => Exec['install-pe'],
  }

  service {'pe-puppet':
    ensure  => 'stopped',
    enable => 'false',
    require => Exec['install-pe'],
  }

}
