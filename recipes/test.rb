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
