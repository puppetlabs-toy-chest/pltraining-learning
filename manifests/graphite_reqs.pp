# Pre-install the graphite packages to speed up installation and
# enable offline use.

class learning::graphite_reqs {
  package { 'libffi-devel':
    ensure => present,
  }
  package { 'openssl-devel':
    ensure => present,
  }
  exec { '/bin/pip install requests[security]':
    require => Package['libffi-devel','openssl-devel'],
  }
  package { 'python-devel':
    before   => Package['twisted','django-tagging','txamqp'],
  }
  package { 'django-tagging':
    ensure => '0.3.1',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'django':
    ensure => '1.5',
    provider => 'pip',
    require => Package['python-pip'],
  }
  package { 'twisted':
    ensure => '11.1.0',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'txamqp':
    ensure => '0.4',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'graphite-web':
    ensure => '0.9.12',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'carbon':
    ensure => '0.9.12',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'whisper':
    ensure => '0.9.12',
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'python-sqlite3dbm':
    ensure => '0.1.4-6.el7',
    require => Exec['/bin/pip install requests[security]'],
  }
}
