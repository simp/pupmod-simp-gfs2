require 'spec_helper'

describe 'gfs2' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { should compile.with_all_deps }
        it { should create_class('gfs2') }
        it { should contain_service('acpid').with_ensure('stopped') }

        context 'virtual_xenu' do
          let(:facts) {
            facts[:virtual] = 'xenu'

            facts
          }

          it { should contain_package('kmod-gnbd-xen') }
          it { should contain_package('libvirt.x86_64') }
        end
      end
    end
  end
end
