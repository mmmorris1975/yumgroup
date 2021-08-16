cb_dir  = ::File.dirname(__FILE__)
cb_name = ::File.basename(cb_dir)

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

task :clean do
  ::Dir.chdir(cb_dir)

  ::File.unlink('metadata.json') if ::File.exist?('metadata.json')

  ::Dir.glob('*.lock').each do |f|
    ::File.unlink(f)
  end
end

task distclean: [:clean] do
  ::Dir.chdir(cb_dir)

  file = ::File.join('..', "#{cb_name}.tar")
  ::File.unlink(file) if ::File.exist? file
end

task knife_test: ['kitchen:all']

task rc: [:cookstyle]
task rubocop: [:cookstyle]
task :cookstyle do
  sh 'bundle exec cookstyle'
end

task :chefspec do
  sh 'bundle exec rspec --color --format documentation'
end

task test: [:cookstyle, :chefspec]
task :test do
  if ::File.exist?(::File.join(cb_dir, 'Strainerfile'))
    sh 'bundle exec strainer test' if ::File.exist?(::File.join(cb_dir, 'Strainerfile'))
  end
end

task :release, [:type] => [:clean, :test, 'kitchen:all'] do |_t, args|
  type = args.type

  if type.nil? || type.strip.empty?
    print "\nEnter release type (major|minor|patch (default)|manual): "
    type = STDIN.gets.chomp
  end

  type = 'patch' if type.nil? || type.strip.empty?

  if type.start_with? 'manual'
    ary = type.split(/\s+/)

    if ary.size != 2
      print "ERROR: manual release type requires a version (ex. manual 1.2.3)\n"
      exit 1
    elsif !ary[1].strip.match(/^\d+\.\d+\.\d+$/)
      print "ERROR: version format must be in the form of x.y.z\n"
      exit 1
    end
  elsif type.strip.match(/^\d+\.\d+\.\d+$/)
    type = "manual #{type}"
  else
    unless type.start_with?('major') || type.start_with?('minor') || type.start_with?('patch')
      print "ERROR: invalid release type of #{type} given\n"
      exit 1
    end
  end

  sh 'bundle exec berks install'
  sh "bundle exec knife spork bump #{cb_name} #{type}"
end

task upload: [:release] do
  sh "bundle exec knife cookbook site share #{cb_name} 'Utilities' -c ~/.knife_opscode.rb"
end
