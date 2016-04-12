require_relative 'spec_helper'

platforms = {
  redhat: %w(6.3 6.4 6.5 7.0),
  centos: %w(6.3 6.4 6.5 7.0),
  fedora: %w(18 19 20 21)
}

yum_makecache_cmd = 'yum -d0 -e0 -y makecache'

platforms.each_pair do |p, v|
  Array(v).each do |ver|
    describe 'yumgroup::_chefspec' do
      # Use an explicit subject
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: p.to_s, version: ver, log_level: :error, step_into: ['yumgroup']) do |node|
          Chef::Log.debug(format('#### FILE: %s  PLATFORM: %s  VERSION: %s ####', ::File.basename(__FILE__), p, ver))

          node.set['hostname'] = 'testhost'
        end.converge(described_recipe)
      end

      let(:shellout) do
        double(run_command: 'yum grouplist -e0', error!: nil, stdout: 'Installed Groups:\n\ttest_group', stderr: 'test_group')
      end
      before do
        Mixlib::ShellOut.stub(:new).and_return(shellout)
      end

      it 'installs yum group test_group' do
        shellout.stub(:stdout).and_return('None')
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
        shellout.stub(:stdout).and_return("Installed Groups:\n\ttest_group")
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
        cache_clean_cmd  = 'yum clean metadata before install cache_group'

        expect(chef_run).to install_yumgroup('install with flush_cache').with(flush_cache: [:before])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall \'cache_group\''

        expect(chef_run).to run_execute(before_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
        expect(chef_run).to_not run_execute(cache_clean_cmd)

        exe = chef_run.execute(cache_clean_cmd)
        expect(exe).to do_nothing
      end

      it 'upgrades yum group cache_group and flushes cache after' do
        before_cache_cmd = 'yum makecache before upgrade cache_group'
        after_cache_cmd  = 'yum makecache after upgrade cache_group'
        cache_clean_cmd  = 'yum clean metadata after upgrade cache_group'

        expect(chef_run).to upgrade_yumgroup('upgrade with flush_cache').with(flush_cache: [:after])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupupdate \'cache_group\''

        expect(chef_run).to run_execute(after_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to_not run_execute(cache_clean_cmd)

        exe = chef_run.execute(cache_clean_cmd)
        expect(exe).to do_nothing
      end

      it 'installs yum group fatal_cache_group with flush_cache after and fatal cache errors' do
        before_cache_cmd = 'yum makecache before install fatal_cache_group'
        after_cache_cmd  = 'yum makecache after install fatal_cache_group'
        cache_clean_cmd  = 'yum clean metadata after install fatal_cache_group'

        expect(chef_run).to install_yumgroup('install with fatal cache errors').with(flush_cache: [:after])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall \'fatal_cache_group\''

        expect(chef_run).to run_execute(after_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to run_execute(cache_clean_cmd)
      end

      it 'upgrades yum group fatal_cache_group with flush_cache before and fatal cache errors' do
        before_cache_cmd = 'yum makecache before upgrade fatal_cache_group'
        after_cache_cmd  = 'yum makecache after upgrade fatal_cache_group'
        cache_clean_cmd  = 'yum clean metadata before upgrade fatal_cache_group'

        expect(chef_run).to upgrade_yumgroup('upgrade with fatal cache errors').with(flush_cache: [:before])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupupdate \'fatal_cache_group\''

        expect(chef_run).to run_execute(before_cache_cmd).with(command: yum_makecache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
        expect(chef_run).to run_execute(cache_clean_cmd)
      end

      it 'installs yum group fatal_cache_group with fatal cache errors, but no flush cache' do
        before_cache_cmd = 'yum makecache before install no_flush_fatal_cache_group'
        after_cache_cmd  = 'yum makecache after install no_flush_fatal_cache_group'
        before_cache_clean_cmd = 'yum clean metadata before install no_flush_fatal_cache_group'
        after_cache_clean_cmd  = 'yum clean metadata after install no_flush_fatal_cache_group'

        expect(chef_run).to install_yumgroup('install with fatal cache errors, but no flush').with(flush_cache: [])
        expect(chef_run).to run_execute 'yum -d0 -e0 -y  groupinstall \'no_flush_fatal_cache_group\''

        expect(chef_run).to_not run_execute(before_cache_cmd)
        expect(chef_run).to_not run_execute(after_cache_cmd)
        expect(chef_run).to_not run_execute(before_cache_clean_cmd)
        expect(chef_run).to_not run_execute(after_cache_clean_cmd)
      end
    end
  end
end
