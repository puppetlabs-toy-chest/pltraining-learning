class learning::quest_tool (
  $content_repo_dir = '/usr/src/puppet-quest-guide'
) {

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
    source => epp('learning/quest.service.epp', {'content_repo_dir' => $content_repo_dir}),
    mode   => '0644',
  }

  service { 'quest':
    provider => systemd,
    ensure   => 'running',
    enable   => true,
    require  => [Package['quest'], File['/etc/systemd/system/quest.service']],
  } 

}
