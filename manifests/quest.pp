class learning::quest ($git_branch='release') {
  
  $doc_root = '/var/www/html/questguide'
  $port     = '80'

  class { 'apache':
    docroot => $doc_root,
  }

  # Create docroot for lvmguide files, so the website files
  # can be put in place

  file { $doc_root:
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '755',
    require => Package['httpd'],
  }

  package { 'tmux':
    ensure  => 'present',
    require => Class['localrepo'],
  }

  package { 'nodejs':
    ensure  => present,
    require => Class['localrepo'],
  }

  package { 'graphviz':
    ensure  => present,
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
    environment => ["GIT_BRANCH=${git_branch}"]
    command     => "/opt/puppet/bin/rake update",
    cwd         => '/usr/src/courseware-lvm/',
    require     => [Exec['install-pe'], Exec['install jekyll'], Vcsrepo['/usr/src/courseware-lvm'], Exec['install rspec']],
  }

  service { 'puppet':
    ensure  => stopped,
    enable  => false,
    require => Exec['install-pe'],
  }

}
