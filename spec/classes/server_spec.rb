require 'spec_helper'

describe 'gfs2::server' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { should create_class('gfs2::server') }
        it { should contain_package('luci').with_ensure('latest') }
      end
    end
  end
end
