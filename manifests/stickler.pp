class learning::stickler(
  $gem_dir = '/var/opt/stickler'
){
  file { $gem_dir:
    ensure => directory,
    before => Service['stickler'],
  }
  $stickler_config_hash = {'gem_dir' => $gem_dir}
  file { '/etc/systemd/system/stickler.service':
    content => epp('stickler/stickler.service.epp', $stickler_config_hash),
    notify  => Service['stickler'],
  }
  service { 'stickler':
    ensure => running,
  }
  package { 'stickler':
    ensure   => present,
    provider => 'gem',
  }
  $stickler_server_hash = {
    'upstream' => 'http://rubygems/org',
    'server'   => 'http://localhost:6789'
  }
  file { '/root/.gem/stickler':
    content => epp('stickler/stickler.epp', $stickler_server_hash),
    notify  => Service['stickler'],
    require => Package['stickler']
  }
}
