class learning (
  $git_branch         = 'master',
  $content_repo_owner = 'puppetlabs',
  $content_repo_name  = 'puppet-quest-guide',
  $include_abalone    = false,
) {

  class { 'learning::quest_guide':
    git_branch         => $git_branch,
    content_repo_owner => $content_repo_owner,
    content_repo_name  => $content_repo_name,
  }

  ## Install learning VM specific things
  include learning::install
  class { 'learning::quest_tool':
    content_repo_dir => "/usr/src/${content_repo_name}",
  }
  include learning::ssh
  include learning::set_defaults

  if $include_abalone { include learning::abalone }

}
