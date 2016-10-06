class learning::abalone {

  include ::abalone

  file { '/etc/securetty':
    ensure => absent,
  }

}
