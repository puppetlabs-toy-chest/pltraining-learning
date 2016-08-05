class learning::dockeragent {
  # Run the dockeragent class to pre-install images
  class { "dockeragent":
    create_no_agent_image => true,
    lvm_bashrc            => true,
  }
  # Install the dockeragent module itself. TODO move this to a more sensible
  # method for pre-installing modules.
  vcsrepo { '/etc/puppetlabs/code/environments/production/modules/dockeragent':
    ensure   => present,
    provider => git,
    source   => "https://github.com/puppetlabs/pltraining-dockeragent.git",
  }  
}
