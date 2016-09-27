class learning::cowsay_directory {

  $module_path = '/etc/puppetlabs/code/environments/production/modules/'

  file { ["${module_path}cowsayings",
          "${module_path}cowsayings/examples",
          "${module_path}cowsayings/manifests"]:
    ensure => directory,
  }

}
