class multi_node {
  include docker
  docker::image { 'phusion/baseimage':}
  docker::run { "webserver":
    image            => 'phusion/baseimage',
    hostname         => "webserver.${::fqdn}",
    extra_parameters => "--add-host puppet:172.17.42.1 --add-host ${::fqdn}:172.17.42.1",
    ports            => ['10080:80'],
  }
  docker::run { "database":
    image    => 'phusion/baseimage',
    hostname => "database.${::fqdn}",
    extra_parameters => "--add-host puppet:172.17.42.1 --add-host ${::fqdn}:172.17.42.1",
    ports    => ['20080:80'],
  }
}
