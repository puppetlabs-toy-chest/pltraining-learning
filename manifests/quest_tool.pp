class learning::quest_tool {

  $home = '/root'

  package { 'tmux':
    ensure  => 'present',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0744',
  }

  file { "${home}/.tmux.conf":
    ensure => file,
    source => 'puppet:///modules/learning/tmux.conf',
  }

  file { "${home}/.bashrc.learningvm":
    ensure => file,
    source => 'puppet:///modules/learning/bashrc.learningvm',
  }

  package { 'quest':
    provider => gem,
    source   => 'http://rubygems.delivery.puppetlabs.net/',
  }

  file { '/etc/systemd/system/quest.service':
    ensure => file,
    source => 'puppet:///modules/learning/quest.service',
  }

  service { 'quest':
    provider => systemd,
    ensure   => 'running',
    enable   => true,
    require  => [Package['quest'], File['/etc/systemd/system/quest.service']],
  } 

}
