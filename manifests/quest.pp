class learning::quest {
  
  $doc_root = '/var/www/html/questguide'
  $port     = '80'

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { 'learning.puppetlabs.vm':
    port    => $port,
    docroot => $doc_root,
  }

  # Create docroot for lvmguide files, so the website files
  # can be put in place

  file { '/var/www/html/questguide':
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

  file { ['/opt/quest', '/opt/quest/bin', '/opt/quest/gems']:
    ensure => directory,
  }

  exec { 'install jekyll':
    command => '/opt/puppet/bin/gem install jekyll -i /opt/quest/gems -n /opt/quest/bin --source https://rubygems.org/',
    creates => '/opt/puppet/bin/jekyll',
    require => [File['/opt/quest/bin'], File['/opt/quest/gems'], Package['nodejs']],
  }

  vcsrepo { '/usr/src/courseware-lvm':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/puppetlabs/courseware-lvm.git',
  }

  exec { 'rake update':
    command => '/opt/puppet/bin/rake update_newest',
    cwd => '/usr/src/courseware-lvm',
    require => [Exec['install-pe'], Exec['install jekyll'], Vcsrepo['/usr/src/courseware-lvm'], Exec['install rspec']],
  }

}
