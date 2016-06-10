# Add default memory settings after PE install

class learning::set_defaults {
  exec { 'mkdir -p /etc/puppetlabs/code':
    path   => '/bin',
    before => File['/etc/puppetlabs/puppet/hiera.yaml','/etc/puppetlabs/code/hieradata']
  }
  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => file,
    source  => 'puppet:///modules/learning/hiera.yaml',
  }
  file { '/etc/puppetlabs/code/hieradata':
    ensure => directory,
  }
  file { '/etc/puppetlabs/code/hieradata/defaults.yaml':
    ensure => file,
    source => 'puppet:///modules/learning/defaults.yaml',
    require => File['/etc/puppetlabs/puppet/hieradata'],
  }
}

