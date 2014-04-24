require 'spec_helper'

%w(httpd crypto-utils httpd-manual mod_perl mod_ssl webalizer).each do |p|
  describe package p do
    it { should be_installed }
  end
end
