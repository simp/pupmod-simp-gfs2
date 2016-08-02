require 'spec_helper'

describe 'gfs2::cluster_allow' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { should create_class('gfs2::cluster_allow') }
      end
    end
  end
end
