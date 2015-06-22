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

  service {'pe-puppet':
    ensure  => 'stopped',
    enabled => 'false',
    require => Exec['install-pe'],
  }

}
