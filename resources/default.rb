unified_mode true

property :group, String, name_property: true
property :options, String
property :flush_cache, Array, default: [], coerce: proc { |x| x.map(&:to_sym) }
property :cache_error_fatal, [true, false], default: false

action_class do
  include Yumgroup::Cookbook::Helpers

  def package_manager
    if platform_family?('rhel') && node['platform_version'].to_i == 7
      # use yum when on CentOS 7
      'yum -q -y'
    else
      # otherwise use dnf on C8 / Fedora
      # (-v is needed to show ids since --ids conflicts with --hidden)
      'dnf -q -y'
    end
  end

  def flush_cache(time)
    # If we want cache update errors to be fatal, we need to remove the local metadata so that when yum tries to fetch
    # the remote data again, it will be seen as a failure. If yum has a local copy it can use, the makecache action will
    # never fail and fall back to using the local metadata instead of raising an error saying there was a problem
    # updating the metadata for a repository.
    #
    # NOTE: this will make metadata updates take much longer!

    if new_resource.flush_cache.include?(time)
      execute "clean metadata #{time} #{new_resource.action[0]} #{new_resource.group}" do
        command "#{package_manager} clean metadata"
        only_if { new_resource.cache_error_fatal }
      end

      execute "makecache #{time} #{new_resource.action[0]} #{new_resource.group}" do
        command "#{package_manager} makecache"
      end
    end
  end
end

%i(install upgrade).each do |a|
  action a do
    # The package type definition in the group can be controlled by a setting called group_package_types. By default,
    # this is 'mandatory' (which appears to include all 'default' packages, as well), but could also be 'optional', or
    # 'default'. We'll keep this default behavior, and allow someone to change it via the options attribute.

    # do nothing unless on a RHEL distro
    return unless platform_family?('rhel') || platform?('fedora') # rubocop:disable Lint/NonLocalExitFromIterator

    flush_cache(:before)

    execute "#{package_manager} group #{a} #{new_resource.options} '#{new_resource.group}'" do
      not_if { installed_groups.include?(new_resource.group) }
    end

    flush_cache(:after)
  end
end

action :remove do
  # Default behavior is to remove every package defined in the group, regardless of the group_package_type. (packages
  # which depend on the packages in the group we are removing will be erased as well) Since a package could reside in
  # multiple groups, this action could have wide, and unexpected, consequences.  The groupremove_leaf_only config option
  # can be used to change this behavior to only remove packages which are not required by other installed packages.

  # do nothing unless on a RHEL distro
  return unless platform_family?('rhel') || platform?('fedora')

  flush_cache(:before)

  execute "#{package_manager} group remove #{new_resource.options} '#{new_resource.group}'" do
    only_if { installed_groups.include?(new_resource.group) }
  end

  flush_cache(:after)
end
