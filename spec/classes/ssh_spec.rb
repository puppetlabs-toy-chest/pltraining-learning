require 'spec_helper'

describe "learning::ssh" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) do
    <<-EOF
      include epel
      include localrepo
      include bootstrap::profile::ruby
      include bootstrap::profile::cache_gems
    EOF
  end

  it { is_expected.to compile.with_all_deps }

end
