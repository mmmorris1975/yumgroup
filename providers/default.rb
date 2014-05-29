# This LWRP will provide a means of installing yum packages via yum groups.  At this point
# we're simply going to trust in the idempotentcy of the yum commands.  We may need to make
# this a bit more robust in the future (a la Chef's yum_package provider), but I need a quick
# and dirty now.
#
# First TODOs:
#  - Provide a do_nothing capability to say that no action was taken to make notifications work in a sane way
#  - Fail if specified group does not exist for :install and :upgrade (configurable?)
#  - Do _not_ fail if group is not installed during :remove

# Support whyrun
def whyrun_supported?
  true
end

# This is the same base yum command Chef's yum_package resource uses.
# controls debug and error level output, as well as automatically accepting all prompts
yum_base_cmd = 'yum -d0 -e0 -y'

def flush_cache(res, sym, action, name)
  fatal = res.cache_error_fatal
  flush = res.flush_cache

  # If we want cache update errors to be fatal, we need to remove the local metadata so
  # that when yum tries to fetch the remote data again, it will be seen as a failure.
  # If yum has a local copy it can use, the makecache action will never fail and fall
  # back to using the local metadata instead of raising an error saying there was a
  # problem updating the metadata for a repository.
  #
  # NOTE: this will make metadata updates take much longer!
  #
  if flush && flush.include?(sym.to_sym)
    execute "yum clean metadata #{sym} #{action} #{name}" do
      command 'yum -d0 -e0 -y clean metadata'
      only_if { fatal }
    end

    execute "yum makecache #{sym} #{action} #{name}" do
      command 'yum -d0 -e0 -y makecache'
    end
  end
end

action :install do
  # The package type definition in the group can be controlled by a setting called
  # group_package_types. By default, this is 'mandatory' (which appears to include all
  # 'default' packages, as well), but could also be 'optional', or 'default'. We'll keep
  # this default behavior, and allow someone to change it via the options attribute.

  grp = @new_resource.group
  cmd = yum_base_cmd + " #{shell_sanitize(@new_resource.options)} groupinstall '#{grp}'"

  converge_by "Installing yum group #{grp}" do
    flush_cache(@new_resource, 'before', 'install', grp)
    execute cmd
    flush_cache(@new_resource, 'after', 'install', grp)
  end
end

action :upgrade do
  # According to the yum docs, groupupdate is just and alias for groupinstall
  # We'll actually call the different yum commands, just in case there's any
  # subtle change in behavior

  grp = @new_resource.group
  cmd = yum_base_cmd + " #{shell_sanitize(@new_resource.options)} groupupdate '#{grp}'"

  converge_by "Upgrading yum group #{grp}" do
    flush_cache(@new_resource, 'before', 'upgrade', grp)
    execute cmd
    flush_cache(@new_resource, 'after', 'upgrade', grp)
  end
end

action :remove do
  # Default behavior is to remove every package defined in the group, regardless of
  # the group_package_type. (packages which depend on the packages in the group we are
  # removing will be erased as well) Since a package could reside in multiple groups,
  # this action could have wide, and unexpected, consequences.  The groupremove_leaf_only
  # config option can be used to change this behavior to only remove packages which are
  # not required by other installed packages.

  grp = @new_resource.group
  cmd = yum_base_cmd + " #{shell_sanitize(@new_resource.options)} groupremove '#{grp}'"

  converge_by "Deleting yum group #{grp}" do
    flush_cache(@new_resource, 'before', 'remove', grp)
    execute cmd
    flush_cache(@new_resource, 'after', 'remove', grp)
  end
end
