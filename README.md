# `yumgroup` Cookbook

This cookbook provides a resource to install RHEL package groups, since the default Yum and DNF `package` providers cannot (CHEF-1392).

## Requirements

- Chef 15.3+

### Supported Platforms

- RHEL & family (e.g. CentOS, Rocky)
- Fedora

## Usage

```ruby
yumgroup 'web-server'
```

### Resource properties

| Property            | Type                       | Default       | Description                                                                                 |
| ------------------- | -------------------------- | ------------- | ------------------------------------------------------------------------------------------- |
| `group`             | String                     | resource name | Name of the group to install. Either the name (`Basic Web Server`) or the id (`web-server`) |
| `options`           | String                     |               | Any options to pass to Yum / DNF when installing                                            |
| `flush_cache`       | Array: `[:before, :after]` | `[]`          | Update the metadata cache before or after the package action                                |
| `cache_error_fatal` | `true` / `false`           | `false`       | Make updates of the metadata cache fatal                                                    |

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: Mike Morris
License: 3-clause BSD
