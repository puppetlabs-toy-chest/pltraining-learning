class learning::dockeragent {
  # Run the dockeragent class to pre-install images
  class { "dockeragent":
    create_no_agent_image => true,
    lvm_bashrc            => true,
  }
}
