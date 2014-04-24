if defined?(ChefSpec)
  def install_yumgroup(name)
    ChefSpec::Matchers::ResourceMatcher.new(:yumgroup, :install, name)
  end

  def upgrade_yumgroup(name)
    ChefSpec::Matchers::ResourceMatcher.new(:yumgroup, :upgrade, name)
  end

  def remove_yumgroup(name)
    ChefSpec::Matchers::ResourceMatcher.new(:yumgroup, :remove, name)
  end
end
