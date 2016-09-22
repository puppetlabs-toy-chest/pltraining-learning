class learning::cowsay_directory {

  $module_path = '/etc/puppetlabs/code/environments/production/modules/'

  file { ["${module_path}cowsay",
          "${module_path}cowsay/examples",
          "${module_path}cowsay/manifests"]:
    ensure => directory,
  }

}
