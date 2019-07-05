# frozen_string_literal: true

require 'spec_helper'

describe 'volatile::file' do
  let(:title) { '/etc/ssl/private/test.pem' }
  let(:facts) { {} }
  let(:params) do
    {
      # ensure: "file",
      # group: "root",
      # mode: "0400",
      # owner: "root",
      # show_diff: false,
      # recurse: false,
      # validate_replacement: "%",
      # content: :undef,
      # source: :undef,
      # recurselimit: :undef,
      # validate_cmd: :undef,

    }
  end

  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  # let (:pre_condition) { "class {'::foobar' }" }
  # it { pp catalogue.resources }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'check default config' do
        it { is_expected.to compile.with_all_deps }
        it do
          ['/var/cache/volatile/etc',
           '/var/cache/volatile/etc/ssl',
           '/var/cache/volatile/etc/ssl/private'
          ].each do |dir|
            is_expected.to contain_file(dir).with(
              ensure: 'directory',
              owner: 'root',
              group: 'root',
              mode: '0400',
            )
          end
        end
        it do
          is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
            ensure: 'file',
            group: 'root',
            mode: '0400',
            owner: 'root',
            show_diff: false,
            recurse: false,
            validate_replacement: '%',
          )
        end
        it do
          is_expected.to contain_file('/etc/ssl/private/test.pem').with(
            ensure: 'link',
            target: '/var/cache/volatile/etc/ssl/private/test.pem',
          )
        end
      end
      describe 'Change Defaults' do
        context 'ensure' do
          before { params.merge!(ensure: 'absent') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'absent',
            )
          end
          it { is_expected.to contain_file('/etc/ssl/private/test.pem').with_ensure('absent') }
          it do
            ['/var/cache/volatile/etc',
            '/var/cache/volatile/etc/ssl',
            '/var/cache/volatile/etc/ssl/private'
            ].each do |dir|
              is_expected.to contain_file(dir).with_ensure('absent')
            end
          end
        end
        context 'group' do
          before { params.merge!(group: 'foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'foobar',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
            )
          end
        end
        context 'mode' do
          before { params.merge!(mode: '4242') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '4242',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
            )
          end
        end
        context 'owner' do
          before { params.merge!(owner: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'foobar',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
            )
          end
        end
        context 'show_diff' do
          before { params.merge!(show_diff: true) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: true,
              recurse: false,
              validate_replacement: '%',
            )
          end
        end
        context 'recurse' do
          before { params.merge!(recurse: true) }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: true,
              validate_replacement: '%',
            )
          end
        end
        context 'validate_replacement' do
          before { params.merge!(validate_replacement: '!') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '!'
            )
          end
        end
        context 'content' do
          before { params.merge!(content: 'foobar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
              content: 'foobar',
            )
          end
        end
        context 'source' do
          before { params.merge!(source: 'puppet:///modules/foo/bar') }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
              source: 'puppet:///modules/foo/bar',
            )
          end
        end
        context 'recurselimit' do
          before { params.merge!(recurselimit: 10) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
              recurselimit: 10,
            )
          end
        end
        context 'validate_cmd' do
          before { params.merge!(validate_cmd: '/bin/foobar') }
          it { is_expected.to compile }
          it do
            is_expected.to contain_file('/var/cache/volatile/etc/ssl/private/test.pem').with(
              ensure: 'file',
              group: 'root',
              mode: '0400',
              owner: 'root',
              show_diff: false,
              recurse: false,
              validate_replacement: '%',
              validate_cmd: '/bin/foobar'
            )
          end
        end
      end
    end
  end
end
