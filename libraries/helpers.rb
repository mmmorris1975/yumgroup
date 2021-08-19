module Yumgroup
  module Cookbook
    module Helpers
      def installed_groups
        list_cmd = if platform_family?('rhel') && node['platform_version'].to_i == 7
                     # use yum when on CentOS 7
                     'yum group list ids hidden'
                   else
                     # otherwise use dnf on C8 / Fedora
                     # (-v is needed to show ids since --ids conflicts with --hidden)
                     'dnf group list --hidden -v'
                   end

        # shell out to get list of groups & ids
        group_list = shell_out!(list_cmd).stdout

        # create groups file if missing
        # there does not appear to be an actual file to check for, so instead use the warning given by yum
        # DNF does not have this problem so this will be C7 only
        if group_list.match?(/There is no installed groups file/)
          shell_out!('yum group mark convert')
          # re-run list comand
          group_list = shell_out!(list_cmd).stdout
        end

        installed_section = false
        group_list.split("\n").map do |g|
          installed_section = true if g =~ /Installed (Environment )?Groups:/
          installed_section = false if g =~ /Available (Environment )?Groups:/
          g.match(/^ +(\w.+) \(([a-z\-]+)\)$/) do |match|
            # ignore non-group lines
            next unless match && installed_section

            # return name and id
            [match[1], match[2]]
          end
        end.flatten
      end
    end
  end
end
