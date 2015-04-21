class learning {

  include learning::quest

  File {
    owner => root,
    group => root,
    mode  => 644,
  }
  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => '/',
  }

  file { '/root/learning.answers':
    ensure => file,
    source => 'puppet:///modules/learning/learning.answers',
  }

  # Print this info when we log in, too.
  file {'/etc/motd':
    ensure => file,
    owner  => root,
    mode   => 0644,
    source => 'puppet:///modules/learning/README',
  }

  file { '/root/README':
    ensure => file,
    source => 'puppet:///modules/learning/README',
  }

  file { '/root/bin':
    ensure => directory,
  }

  file { '/var/lib/hiera':
    ensure => directory,
  }
  file { '/var/lib/hiera/defaults.yaml':
    ensure => file,
    source => 'puppet:///modules/learning/defaults.yaml',
    require => File['/var/lib/hiera'],
  }

}
