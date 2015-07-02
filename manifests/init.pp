class learning ($git_branch='release') {

  class { '::learning::quest':
    git_branch => $git_branch
  }
  contain learning::quest

  File {
    owner => root,
    group => root,
    mode  => 644,
  }
  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => '/',
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

  ## Install learning VM specific things
  include learning::install

}
