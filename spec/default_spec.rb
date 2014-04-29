require 'spec_helper'

platforms = {
  redhat: %w(6.3 6.4 6.5),
  centos: %w(6.3 6.4 6.5),
  fedora: %w(18 19 20)
}

yum_makecache_cmd = 'yum -d0 -e0 -y makecache'

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
        before_cache_cmd = 'yum makecache before install test_group'
        after_cache_cmd  = 'yum makecache after install test_group'

        expect(chef_run).to install_yumgroup('install test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall \'test_group\''

        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
      end

      it 'upgrades yum group test_group' do
        before_cache_cmd = 'yum makecache before upgrade test_group'
        after_cache_cmd  = 'yum makecache after upgrade test_group'

        expect(chef_run).to upgrade_yumgroup('upgrade test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupupdate \'test_group\''

        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
      end

      it 'removes yum group test_group' do
        before_cache_cmd = 'yum makecache before remove test_group'
        after_cache_cmd  = 'yum makecache after remove test_group'

        expect(chef_run).to remove_yumgroup('remove test_group').with(group: 'test_group')
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupremove \'test_group\''

        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
      end

      it 'installs yum group cache_group and flushes cache before' do
        before_cache_cmd = 'yum makecache before install cache_group'
        after_cache_cmd  = 'yum makecache after install cache_group'

        expect(chef_run).to install_yumgroup('install with flush_cache').with(flush_cache: [:before])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall \'cache_group\''

        expect(chef_run).to run_execute(before_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
      end

      it 'upgrades yum group cache_group and flushes cache after' do
        before_cache_cmd = 'yum makecache before upgrade cache_group'
        after_cache_cmd  = 'yum makecache after upgrade cache_group'

        expect(chef_run).to upgrade_yumgroup('upgrade with flush_cache').with(flush_cache: [:after])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupupdate \'cache_group\''

        expect(chef_run).to run_execute(after_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(before_cache_cmd)
      end
    end
  end
end
