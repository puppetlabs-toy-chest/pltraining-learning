class learning::install {
  
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'

  include learning::multi_node

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
