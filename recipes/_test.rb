yumgroup 'install test_group' do
  group 'test_group'
  action :install
end

yumgroup 'upgrade test_group' do
  group 'test_group'
  action :upgrade
end

yumgroup 'remove test_group' do
  group 'test_group'
  action :remove
end

yumgroup 'install with flush_cache' do
  group 'cache_group'
  flush_cache [:before]
  action :install
end

yumgroup 'upgrade with flush_cache' do
  group 'cache_group'
  flush_cache [:after]
  action :upgrade
end
