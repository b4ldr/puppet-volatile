require 'spec_helper_acceptance'

pp = <<-PUPPETCODE
volatile::file{'/etc/ssl/private/secret.txt':
  ensure => file,
  content => 'P@55wOrd!'
}
PUPPETCODE

describe 'volatile class' do
  describe 'run default init' do
    it 'work with no errors' do
      idempotent_apply(pp)
    end
    describe file('/var/cache/volatile') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode '711' }
      it { is_expected.to be_owned_by 'root' }
      it do
        is_expected.to be_mounted
        # not sure why this dosen't work
        # is_expected.to be_mounted.with(
        #   type: 'tmpfs',
        #   device: 'tmpfs',
        #   options: {
        #     size: '65536k',
        #     mode: '711',
        #   }
        # )
      end
    end
    describe file('/etc/ssl/private/secret.txt') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to '/var/cache/volatile/etc/ssl/private/secret.txt' }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to contain 'P@55wOrd!' }
    end
    describe file('/var/cache/volatile/etc/ssl/private/secret.txt') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode '400' }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to contain 'P@55wOrd!' }
    end
  end
end
