class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'

  # Install mutli_node module
  include learning::multi_node

  package { 'python-pip':
    ensure => 'present',
    require => Class['epel'],
  }

  # Symlink pip to /usr/bin/pip-python where the provider expects it
  file { '/usr/bin/pip-python':
    ensure  => symlink,
    target  => '/usr/bin/pip',
    require => Package['python-pip']
  }

  # This class sets up a local pypi server so we can run offline
  class { 'learning::pypi_server':
    pypi_dir     => '/opt/pypiserver',
    pypi_pkg_dir => '/opt/pypiserver/packages',
    require      => File['/usr/bin/pip-python'],
  }

  # Install or cache everything we need for graphite
  class { 'learning::graphite_reqs':
    pypi_dir     => '/opt/pypiserver',
    pypi_pkg_dir => '/opt/pypiserver/packages',
    require      => Class['learning::pypi_server'],
  }

  # Set up an apache server and vhost to serve graphite
  include learning::graphite_server
 

  file {[ "$prod_module_path", 
          "${prod_module_path}/cowsayings",
          "${prod_module_path}/cowsayings/manifests",
          "${prod_module_path}/cowsayings/examples"]: 
    ensure => directory,
  }

  service {['pe-puppet', 'puppet']:
    ensure  => 'stopped',
    enable => 'false',
  }

  package { 'graphviz':
    ensure  => 'present',
  }

  file { ['/etc/motd', '/root/README']:
    ensure => 'file',
    owner  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/learning/README',
  }

  file { '/var/lib/hiera':
    ensure => directory,
  }

}
