require 'spec_helper'

if os[:release].to_i < 7
  pkgs = %w(httpd crypto-utils httpd-manual mod_perl mod_ssl webalizer)
else
  pkgs = %w(httpd crypto-utils httpd-manual mod_ssl)
end

pkgs.each do |p|
  describe package p do
    it { should be_installed }
  end
end
