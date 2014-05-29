yumgroup node['yum'][node['platform']]['group'] do
  action :install
end

# Uncomment the below lines to test the behavior of cache_error_fatal setting
#cookbook_file 'bogus_yum.repo' do
#  path '/etc/yum.repos.d/bogus_yum.repo'
#  action :create_if_missing
#  owner 'root'
#  group 'root'
#  mode  '644'
#end
#
#yumgroup 'x' do
#  action :install
#  flush_cache [:before]
#  cache_error_fatal true
#end
