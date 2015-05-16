require 'spec_helper'

describe 'gfs2::server' do

  it { should create_class('gfs2::server') }
  it { should contain_package('luci').with_ensure('latest') }
end
