class learning (
  $git_branch = 'master',
  $include_abalone = false,  
) {

  class { 'learning::quest_guide':
    git_branch => $git_branch,
  }

  ## Install learning VM specific things
  include learning::install
  include learning::quest_tool
  include learning::ssh
  include learning::set_defaults
  include learning::cowsay_directory

  if $include_abalone { include abalone }
}
