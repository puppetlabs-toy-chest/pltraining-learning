class learning::quest {

  # Create docroot for lvmguide files, so the website files
  # can be put in place
  file { '/var/www/html/lvmguide':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '755',
    require => Package['httpd'],
  }

  package { 'tmux':
    ensure => 'present',
    require => Class['localrepo'],
  }

  package { 'nodejs':
    ensure => present,
    require => Class['localrepo'],
  }

  exec { 'install bundler':
    command => '/opt/puppet/bin/gem install bundler',
    unless => '/opt/puppet/bin/gem bundler -i',
    require => Exec['install-pe'],
  }

  vcsrepo { '/usr/src/courseware-lvm':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/puppetlabs/courseware-lvm.git',
  }

  exec { 'bundle install':
    command => '/opt/puppet/bin/bundle install',
    cwd => '/usr/src/courseware-lvm',
    require => [Exec['install bundler'], Package['nodejs'], Vcsrepo['/usr/src/courseware-lvm']],
  }

  exec { 'bundle exec rake update_newest':
    cwd => '/usr/src/courseware-lvm',
    require => Exec['bundle install'],
  }

}
