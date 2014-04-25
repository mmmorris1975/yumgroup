yumgroup node['yum'][node['platform']]['group'] do
  action :install
end
