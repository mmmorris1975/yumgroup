name 'yumgroup'
maintainer 'Mike Morris'
maintainer_email 'michael.m.morris@gmail.com'
license '3-clause BSD'
description 'Installs/Configures yum packages via yum groups'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.6.0'

supports 'redhat', '>= 5.0'
supports 'centos', '>= 5.0'
supports 'fedora', '>= 19.0'
supports 'fedora', '< 22.0'
