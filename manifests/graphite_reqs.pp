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
  # Workaround for package installation target that isn't recognized by
  # pip.
  # https://github.com/graphite-project/carbon/issues/86
  file { '/usr/lib/python2.6/site-packages/graphite_web-0.9.12-py2.6.egg-info':
    target  => '/opt/graphite/webapp/graphite_web-0.9.12-py2.6.egg-info',
    require => Package['graphite-web'],
    ensure  => link,
  }
  file { '/usr/lib/python2.6/site-packages/carbon-0.9.12-py2.6.egg-info':
    target  => '/opt/graphite/lib/carbon-0.9.12-py2.6.egg-info',
    require => Package['carbon'],
    ensure  => link,
  }
}
