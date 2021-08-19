log 'fedora warn' do
  message "\nThis might take a while, there are a lot of optional packages on Fedora"
  level :warn
  only_if { platform?('fedora') }
end

yumgroup 'web-server' do
  if node['platform_version'].to_i >= 8
    options '--with-optional'
  else
    # yum does not have --with-optional
    options '--setopt=group_package_types=mandatory,default,optional'
  end
end

# Uncomment the following lines to test the behavior of cache_error_fatal setting
# cookbook_file 'bogus_yum.repo' do
#   path '/etc/yum.repos.d/bogus_yum.repo'
#   action :create_if_missing
#   owner 'root'
#   group 'root'
#   mode  '644'
# end

# yumgroup 'x' do
#   action :upgrade
#   flush_cache ['before']
#   cache_error_fatal true
# end
