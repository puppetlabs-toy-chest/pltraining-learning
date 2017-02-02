class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'

  # Install mutli_node module
  include learning::multi_node
  include pe_repo::platform::ubuntu_1404_amd64

  # Install pltraining-dockeragent module
  include docker
  include learning::dockeragent

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
  #class { 'learning::pypi_server':
  #  pypi_dir     => '/opt/pypiserver',
  #  pypi_pkg_dir => '/opt/pypiserver/packages',
  #  require      => File['/usr/bin/pip-python'],
  #}

  # Install or cache everything we need for graphite
  #class { 'learning::graphite_reqs':
  #  pypi_dir     => '/opt/pypiserver',
  #  pypi_pkg_dir => '/opt/pypiserver/packages',
  #  require      => Class['learning::pypi_server'],
  #}

  # Set up an apache server and vhost to serve graphite
  include learning::graphite_server

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

  file { '/usr/local/bin/reset_demo':
    ensure => 'file',
    owner  => 'root',
    mode   => '0500',
    source => 'puppet:///modules/learning/reset_demo',
  }

  #enable GSSAPIAuthentication so we can disable it in the quest
  file_line { 'sshd_config':
    ensure => present,
    path   => '/etc/ssh/sshd_config',
    line   => 'GSSAPIAuthentication yes',
    match  => '^GSSAPIAuthentication',
  }

}
