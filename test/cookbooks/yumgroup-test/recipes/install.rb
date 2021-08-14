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
