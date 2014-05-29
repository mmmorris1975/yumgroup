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

yumgroup 'install with fatal cache errors' do
  group 'fatal_cache_group'
  flush_cache [:after]
  cache_error_fatal true
  action :install
end

yumgroup 'upgrade with fatal cache errors' do
  group 'fatal_cache_group'
  flush_cache [:before]
  cache_error_fatal true
  action :upgrade
end

yumgroup 'install with fatal cache errors, but no flush' do
  group 'no_flush_fatal_cache_group'
  cache_error_fatal true
  action :install
end
