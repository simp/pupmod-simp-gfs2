require 'spec_helper'

describe 'gfs2' do

  it { should compile.with_all_deps }
  it { should create_class('gfs2') }
  it { should contain_service('acpid').with_ensure('stopped') }

  context 'virtual_xenu' do
    base_facts = {
      :virtual         => 'xenu',
      :hardwaremodel   => 'x86_64'
    }

    let(:facts) {base_facts}

    it { should contain_package('kmod-gnbd-xen') }
    it { should contain_package('libvirt.x86_64') }
  end
end
