# Pre-install the graphite packages to speed up installation and
# enable offline use.

class learning::graphite_reqs {
  include wget
  class { 'supervisord':
    install_pip => true,
  }
  $pypi_pkg_dir = '/opt/pypiserver/packages'
  #Define the files we need to cache for pip
  $pypi_root = "https://pypi.python.org/packages/source"
  $pip_urls = [
    "${pypi_root}/D/Django/Django-1.5.tar.gz",
    "${pypi_root}/c/carbon/carbon-0.9.12.tar.gz",
    "${pypi_root}/T/Twisted/Twisted-11.1.0.tar.bz2",
    "${pypi_root}/t/txAMQP/txAMQP-0.4.tar.gz",
    "${pypi_root}/g/graphite-web/graphite-web-0.9.12.tar.gz",
    "${pypi_root}/d/django-tagging/django-tagging-0.3.1.tar.gz",
    "${pypi_root}/w/whisper/whisper-0.9.12.tar.gz"
  ]
  # wget all the pip packages
  $pip_urls.each | $url | {
    $basename = inline_template('<%= File.basename(@url) %>')
    wget::fetch { $url:
      destination => "${pypi_pkg_dir}/${basename}",
    }
  }
  # Define the pip configuration to point to the local server.
  $pip_conf = @(END)
  [global]
  index-url = http://localhost:8180/simple/
  | END
  # Set up a pypi server so we can use pip with local packages
  file { ['/opt/pypiserver', '/opt/pypiserver/packages']:
    ensure => 'directory',
    mode   => '0640',
    before => Supervisord::Program['pypi-server'],
  }
  supervisord::program { 'pypi-server':
    command     => "pypi-server -p 8180 ${pypi_pkg_dir}",
    user        => 'root',
    autostart   => true,
    autorestart => true,
    priority    => '100',
  }
  file { ['/root/.config', '/root/.config/pip']:
    ensure => directory,
  }
  file { '/root/.config/pip/pip.conf':
    ensure  => present,
    content => $pip_conf,
  }
  exec { '/bin/pip install requests[security] --index "https://pypi.python.org/simple/"':
    require => Package['libffi-devel','openssl-devel', 'python-devel'],
  }
  package { 'libffi-devel':
    ensure => present,
  }
  package { 'openssl-devel':
    ensure => present,
  }
  package { 'python-devel':
    ensure => present,
  }
  package { 'python-sqlite3dbm':
    ensure => '0.1.4-6.el7',
    require => Exec['/bin/pip install requests[security] --index "https://pypi.python.org/simple/"'],
  }
#  package { 'django':
#    ensure => '1.5',
#    provider => 'pip',
#    require => Package['python-pip'],
#  }
#  package { 'twisted':
#    ensure => '11.1.0',
#    provider => 'pip',
#    require  => Package['python-pip'],
#  }
#  package { 'txamqp':
#    ensure => '0.4',
#    provider => 'pip',
#    require  => Package['python-pip'],
#  }
#  package { 'graphite-web':
#    ensure => '0.9.12',
#    provider => 'pip',
#    require  => Package['python-pip'],
#  }
#  package { 'carbon':
#    ensure => '0.9.12',
#    provider => 'pip',
#    require  => Package['python-pip'],
#  }
}
