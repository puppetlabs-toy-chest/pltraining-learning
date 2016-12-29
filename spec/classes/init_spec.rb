require 'spec_helper'

describe "learning" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :path                      => '/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    :pe_compile_master         => 'false',
    :pe_build                  => '2016.2',
    :aio_agent_version         => '4.5.2',
    :os                        => {
      :family => 'RedHat',
      :release => {
        :major => '7',
        :minor => '2',
      }
    },
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :kernel                    => 'Linux',
    :kernelversion             => '3.10.0',
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) {
    <<-EOF
      include pe_repo
      include localrepo
      include epel
      include nginx
      include bootstrap::profile::ruby
      include bootstrap::profile::cache_gems
    EOF
  }

  it { is_expected.to compile }

  it {
    is_expected.to contain_class("learning::quest_guide")
      .with({
        'git_branch'         => 'master',
        'content_repo_owner' => 'puppetlabs',
        'content_repo_name'  => 'puppet-quest-guide',
      })
  }

  it {
    is_expected.to contain_class("learning::quest_tool")
      .with({
        'content_repo_dir' => '/usr/src/puppet-quest-guide',
      })
  }

end
