class learning::quest ($git_branch='release') {
  
  $doc_root = '/var/www/html/questguide/'
  $proxy_port = '80'
  $quest_port = '85'
  $graph_port = '90'

  class { '::apache':
    default_vhost => false,
  }

  # Create a proxy to pass to the Quest Guide and graphite server

  apache::vhost { "*:${proxy_port}":
    port       => $proxy_port,
    docroot    => $doc_root,
    proxy_pass => [
      { 'path' => '/graphite', 'url' => "http://localhost:${graph_port}"},
      { 'path' => '*', 'url' => "http://localhost:${quest_port}"},
    ],
  }

  # Serve the Quest Guide

  apache::vhost { "*:${quest_port}":
    port    => $quest_port,
    docroot => $doc_root,
  }

  # Serve Graphite

  apache::vhost { "*:${graph_port}":
    manage_docroot => false,
    port           => $graph_port,
    docroot        => '/opt/graphite/webapp',
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'graphite',
    wsgi_daemon_process_options => {
      processes          => '5',
      threads            => '5',
      display-name       => '%{GROUP}',
      inactivity-timeout => '120',
    },
    wsgi_import_script          => '/opt/graphite/conf/graphite.wsgi',
    wsgi_import_script_options  => {
      process-group     => 'graphite',
      application-group => '%{GLOBAL}'
    },
    wsgi_process_group          => 'graphite',
    wsgi_script_aliases         => {
      '/' => '/opt/graphite/conf/graphite.wsgi'
    },
    headers => [
      'set Access-Control-Allow-Origin "*"',
      'set Access-Control-Allow-Methods "GET, OPTIONS, POST"',
      'set Access-Control-Allow-Headers "origin, authorization, accept"',
    ],
    directories => [{
      path => '/media/',
      order => 'deny,allow',
      allow => 'from all'}
    ]
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

  package { 'python-django-tagging':
    ensure => '0.3.1',
    require => [Class['localrepo'], Package['python-pip']],
    provider => 'pip',
  }

  package { 'python-pip':
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
    environment => ["GH_BRANCH=${git_branch}"],
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
