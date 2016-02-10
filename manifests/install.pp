class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'

  file {[ "$prod_module_path", 
          "${prod_module_path}/cowsayings",
          "${prod_module_path}/cowsayings/manifests",
          "${prod_module_path}/cowsayings/examples",
        ]: 
    ensure => directory,
  }

  service {'pe-puppet':
    ensure  => 'stopped',
    enable => 'false',
  }

  # Install mutli_node module
  include learning::multi_node
}
