yumgroup Cookbook
=================

A LWRP to install yum packages based on yum groups. This is a stop gap measure while we wait for CHEF-1392, since I have an itch to scratch right now (heck maybe this morphs into the solution for that ticket?)

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - yumgroup needs toaster to brown your bagel.

#### platforms
Any platform that supports installing packages via yum using yum groups.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### yumgroup::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['yumgroup']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### yumgroup::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `yumgroup` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[yumgroup]"
  ]
}
```

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
