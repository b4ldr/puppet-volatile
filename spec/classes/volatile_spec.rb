require 'spec_helper'

describe 'volatile' do
  let(:node) { 'foobar.example.com' }
  let(:params) do
    {
      # ensure: "present",
      # mountpoint: "/var/cache/volatile",
      # size: "64M",
      # owner: "root",
      # group: "root",
      # mode: "0611",
    }
  end

  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # This will need to get moved
  # it { pp catalogue.resources }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/var/cache/volatile').with(
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0611',
          )
        end
        it do
          is_expected.to contain_mount('/var/cache/volatile').with(
            ensure: 'mounted',
            device: 'tmpfs',
            fstype: 'tmpfs',
            options: 'size=64M,mode=0611,uid=root,gid=root',
            atboot: true,
          )
        end
      end
      describe 'Change Defaults' do
        context 'ensure' do
          before(:each) { params.merge!(ensure: 'absent') }
          it { is_expected.to compile }
          it { is_expected.to contain_file('/var/cache/volatile').with_ensure('absent') }
          it { is_expected.to contain_mount('/var/cache/volatile').with_ensure('absent') }
        end
        context 'mountpoint' do
          before(:each) { params.merge!(mountpoint: '/foo/bar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/foo/bar').with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '0611',
            )
          end
          it do
            is_expected.to contain_mount('/foo/bar').with(
              ensure: 'mounted',
              device: 'tmpfs',
              fstype: 'tmpfs',
              options: 'size=64M,mode=0611,uid=root,gid=root',
              atboot: true,
            )
          end
        end
        context 'size' do
          before(:each) { params.merge!(size: '42M') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_mount('/var/cache/volatile').with(
              ensure: 'mounted',
              device: 'tmpfs',
              fstype: 'tmpfs',
              options: 'size=42M,mode=0611,uid=root,gid=root',
              atboot: true,
            )
          end
        end
        context 'owner' do
          before(:each) { params.merge!(owner: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/var/cache/volatile').with(
              ensure: 'present',
              owner: 'foobar',
              group: 'root',
              mode: '0611',
            )
          end
          it do
            is_expected.to contain_mount('/var/cache/volatile').with(
              ensure: 'mounted',
              device: 'tmpfs',
              fstype: 'tmpfs',
              options: 'size=64M,mode=0611,uid=foobar,gid=root',
              atboot: true,
            )
          end
        end
        context 'group' do
          before(:each) { params.merge!(group: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile').with(
              ensure: 'present',
              owner: 'root',
              group: 'foobar',
              mode: '0611',
            )
          end
          it do
            is_expected.to contain_mount('/var/cache/volatile').with(
              ensure: 'mounted',
              device: 'tmpfs',
              fstype: 'tmpfs',
              options: 'size=64M,mode=0611,uid=root,gid=foobar',
              atboot: true,
            )
          end
        end
        context 'mode' do
          before(:each) { params.merge!(mode: '1777') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile').with(
              ensure: 'present',
              owner: 'root',
              group: 'root',
              mode: '1777',
            )
          end
          it do
            is_expected.to contain_mount('/var/cache/volatile').with(
              ensure: 'mounted',
              device: 'tmpfs',
              fstype: 'tmpfs',
              options: 'size=64M,mode=1777,uid=root,gid=root',
              atboot: true,
            )
          end
        end
      end
    end
  end
end
