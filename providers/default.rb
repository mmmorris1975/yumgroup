# This LWRP will provide a means of installing yum packages via yum groups.  At this point
# we're simply going to trust in the idempotentcy of the yum commands.  We may need to make
# this a bit more robust in the future (a la Chef's yum_package provider), but I need a quick
# and dirty now.
#
# First TODOs:
#  - Fail if specified group does not exist for :install and :upgrade
#  - Do _not_ fail if group is not installed during :remove

# Support whyrun
def whyrun_supported?
  true
end

# This is the same base yum command Chef's yum_package resource uses.
# controls debug and error level output, as well as automatically accepting all prompts
yum_base_cmd = 'yum -d0 -e0 -y'

action :install do
  # The package type definition in the group can be controlled by a setting called
  # group_package_types. By default, this is 'mandatory' (which appears to include all
  # 'default' packages, as well), but could also be 'optional', or 'default'. We'll keep
  # this default behavior, and allow someone to change it via the options attribute.

  grp = @new_resource.group
  cmd = yum_base_cmd + " #{shell_sanitize(@new_resource.options)} groupinstall '#{grp}'"

  converge_by "Installing yum group #{grp}" do
    execute cmd
  end
end

action :upgrade do
  # According to the yum docs, groupupdate is just and alias for groupinstall
  # We'll actually call the different yum commands, just in case there's any
  # subtle change in behavior

  grp = @new_resource.group
  cmd = yum_base_cmd + " #{shell_sanitize(@new_resource.options)} groupupdate '#{grp}'"

  converge_by "Upgrading yum group #{grp}" do
    execute cmd
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
    execute cmd
  end
end
