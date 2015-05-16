require 'spec_helper'

describe 'gfs2::cluster_allow' do

  base_facts = {
    :operatingsystem => 'RedHat',
    :lsbdistrelease  => '6'
  }

  let(:facts) {base_facts}

  it { should create_class('gfs2::cluster_allow') }
end
