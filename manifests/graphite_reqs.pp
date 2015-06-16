# Pre-install the graphite packages to speed up installation and
# enable offline use.

class learning::graphite_reqs {
  Package {
    provider => 'pip',
    require  => Package['python-pip'],
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
    ensure => '0.9.12',
  }
  package { 'carbon':
    ensure => '0.9.12',
  }
  package { 'whisper':
    ensure => '0.9.12',
  }
}
