actions :install, :upgrade, :remove
default_action :install

# The name of the yum group to manage
attribute :group, kind_of: String, name_attribute: true, required: true

# Options to pass to the yum command
attribute :options, kind_of: String

attribute :flush_cache, kind_of: Array, default: []
attribute :cache_error_fatal, kind_of: [TrueClass, FalseClass], default: false
