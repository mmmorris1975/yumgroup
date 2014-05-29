yumgroup node['yum'][node['platform']]['group'] do
  action :upgrade
end

# Uncomment the below lines to test the behavior of cache_error_fatal setting
# cookbook_file 'bogus_yum.repo' do
#   path '/etc/yum.repos.d/bogus_yum.repo'
#   action :create_if_missing
#   owner 'root'
#   group 'root'
#   mode  '644'
# end
#
# yumgroup 'x' do
#   action :upgrade
#   flush_cache [:after]
#   cache_error_fatal true
# end
