class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/puppet/environments/production/modules'

  # Add script that can print console login. Bootstrap will optionally call this in the rc.local file.
  file {'/root/.console_login.sh':
    ensure => file,
    source => 'puppet:///modules/learning/console_login.sh',
    mode   => '0755',
  }

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

  # Add the installer files for 32 bit agents
  # This will prevent errors when puppet runs offline

  include pe_repo::platform::el_6_i386

}
