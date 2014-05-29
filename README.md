yumgroup Cookbook
=================

A LWRP to install yum packages based on yum groups. This is a stop gap measure while we wait for CHEF-1392, since I have an itch to scratch right now (heck maybe this morphs into the solution for that ticket?)

Requirements
------------

#### platforms
Any platform that supports installing packages via yum using yum groups.  
NOTE: Fedora 18 will work with the :install and :upgrade actions, however the :remove action may be flaky, and attempt to delete everything in the dependency tree (regardless of the value of the groupremove\_leaf\_only setting!)

Usage
-----
#### yumgroup::default

Just include the `yumgroup` recipe in your cookbook to get access to the LWRP:

```ruby
include_recipe 'yumgroup'

yumgroup 'Web Server' do
  action :install
end
```

The yumgroup lwrp provides 2 additional attributes that can be set to control its behavior:

* flush\_cache - Update the yum metadata cache before or after the yum action (similar to the yum\_package resource)
* cache\_error\_fatal - Make updates of the metadata cache fatal (by default they are not)

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Mike Morris  
License: 3-clause BSD
