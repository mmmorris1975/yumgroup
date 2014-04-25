yumgroup node['yum'][node['platform']]['group'] do
  action :upgrade
end
