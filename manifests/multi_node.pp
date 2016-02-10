class learning::multi_node {
  file { '/etc/puppetlabs/code/modules':
    ensure => directory,
    before => File['/etc/puppetlabs/code/modules/multi_node']
  }
  file { '/etc/puppetlabs/code/modules/multi_node':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/learning/multi_node',
  }
}
