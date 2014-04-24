require 'spec_helper'

platforms = {
  redhat: %w(6.3 6.4 6.5),
  centos: %w(6.3 6.4 6.5),
  fedora: %w(18 19 20)
}

platforms.each_pair do |p, v|
  Array(v).each do |ver|
    describe 'yumgroup::_test' do
      # Use an explicit subject
      let(:chef_run) do
        ChefSpec::Runner.new(platform: p.to_s, version: ver, log_level: :warn, step_into: ['yumgroup']) do |node|
          Chef::Log.debug(format('#### FILE: %s  PLATFORM: %s  VERSION: %s ####', ::File.basename(__FILE__), p, ver))

          node.set['hostname'] = 'testhost'
        end.converge(described_recipe)
      end

      it 'installs yum group test_group' do
        expect(chef_run).to install_yumgroup('install test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall test_group'
      end

      it 'upgrades yum group test_group' do
        expect(chef_run).to upgrade_yumgroup('upgrade test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupupdate test_group'
      end

      it 'removes yum group test_group' do
        expect(chef_run).to remove_yumgroup('remove test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupremove test_group'
      end
    end
  end
end
