class learning::dockeragent {
  vcsrepo { '/etc/puppetlabs/code/environments/production/modules/dockeragent':
    ensure   => present,
    provider => git,
    source   => "https://github.com/puppetlabs/pltraining-dockeragent.git",
  }  
}
