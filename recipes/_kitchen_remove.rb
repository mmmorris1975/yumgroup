yumgroup node['yum'][node['platform']]['group'] do
  action :install
end

yumgroup node['yum'][node['platform']]['group'] do
  action :remove
end
