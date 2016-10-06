require 'spec_helper'

describe "learning::quest_guide_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  let(:pre_condition) do
    <<-EOF
      include learning::quest_guide
    EOF
  end

  it { is_expected.to compile.with_all_deps }

end
