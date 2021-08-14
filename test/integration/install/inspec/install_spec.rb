control 'default' do
  title 'Default and mandatory web-server packages'

  %w(
    httpd
    httpd-manual
    mod_fcgid
    mod_ssl
  ).each do |p|
    describe package p do
      it { should be_installed }
    end
  end
end

control 'optional' do
  title 'Optional web-server packages'

  # optional packages are different between CentOS and Fedora
  pkgs = if os.redhat?
           %w(
             libmemcached
             memcached
             mod_security
             mod_security_crs
           )
         else
           %w(
             apachetop
             awstats
             bes
             drupal7
             lighttpd
             lighttpd-fastcgi
             mediawiki
             mod_auth_gssapi
             mod_fcgid
             mod_geoip
             mod_security
             mod_xsendfile
             ocspd
             perl-HTML-Mason
             perl-Kwiki
             php-odbc
             php-pecl-apcu-bc
             php-pgsql
             phpMyAdmin
             phpldapadmin
             thttpd
             wordpress
           )
         end
  pkgs.each do |p|
    describe package p do
      it { should be_installed }
    end
  end
end
