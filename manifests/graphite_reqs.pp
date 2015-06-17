# Pre-install the graphite packages to speed up installation and
# enable offline use.

class learning::graphite_reqs {
  Package {
    provider => 'pip',
    require  => Package['python-pip'],
  }
  package { 'python-devel':
    provider => 'yum',
    before   => Package['twisted','django-tagging','txamqp'],
  }
  package { 'django-tagging':
    ensure => '0.3.1',
  }
  package { 'twisted':
    ensure => '11.1.0',
  }
  package { 'txamqp':
    ensure => '0.4',
  }
  package { 'graphite-web':
    ensure => present,
  }
  package { 'carbon':
    ensure => present,
  }
  package { 'whisper':
    ensure => present,
  }
}
