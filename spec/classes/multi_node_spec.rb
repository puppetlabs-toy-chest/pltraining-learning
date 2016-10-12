require 'spec_helper'

describe "learning::multi_node" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

end
