# All these functions are available as Monk.xxxx.
# (eg, Monk.tasks_for)
#
module Monk::Helpers
  def config
    @config ||= Monk::Config.load
  end

  def tasks_for(category)
    tasks.select { |name, t| t.category == category }
  end

  def other_tasks
    tasks.select { |name, t| t.category.nil? }
  end

  def rvm?
    @has_rvm = (!! `rvm` rescue false)  if @has_rvm.nil?
    @has_rvm
  end

  # Reads the gems manifest file and returns the gems to be installed.
  def gems_from_manifest(manifest='.gems')
    gems = File.read(manifest).split("\n")
    gems.reject { |name| name =~ /^\s*(#|$)/ }
  end

  # Returns the name of the current RVM gemset.
  def rvm_gemset
    File.basename(`rvm current`.strip)
  end

  def rvm_ruby_version
    rvm_gemset.split('@').first
  end

  def ensure_rvm
    return true  if rvm?
    err "You need RVM installed for this command."
    err "See http://rvm.beginrescueend.com for more info."
  end

  # Checks if a certain gem is installed.
  # The format is the same as that found in the .gems file.
  #
  # @example
  #   has_gem?('nest -v1.1.0')
  #
  def has_gem?(str)
    _, name, version = str.match(/^([A-Za-z_\-]+) -v(.*)$/).to_a
    name    ||= str
    version ||= ">=0"

    begin
      gem(name, version)
      true
    rescue Gem::LoadError
      false
    end
  end

  # Performs a given block in the given path.
  def in_path(path, &blk)
    old = Dir.pwd
    Dir.chdir path
    say_status :cd, path
    yield
    Dir.chdir old
  end

  # Loads the monkfile. Used by bin/monk.
  def load_monkfile
    file = find_in_project("Monkfile")

    if file
      load file
      @project = File.dirname(file)
      Dir.chdir @project
    end
  end

  def show_help_for(task)
    name = params.first
    task = task(name)
    pass "No such command. Try: #{executable} help"  unless task

    help = task.help
    if help
      help.each { |line| err line }
      err
    else
      err "Usage: #{executable} #{task.usage || name}"
      err "#{task.description}."  if task.description
    end
  end

  # Checks if there is a loaded project or not.
  def project?
    ! @project.nil?
  end

  # File expand: fx('~/.cache/monk')
  def fx(*paths)
    File.expand_path File.join(*paths.join('/').split('/'))
  end

  def system(cmd)
    say_status :run, cmd
    super
  end

  def system_q(cmd)
    say_status :run, cmd
    `#{cmd}`
  end

  def say_info(str)
    say_status '*', str, 30
  end

  def say_status(what, cmd, color=32)
    c1 = "\033[0;#{color}m"
    c0 = "\033[0;m"
    puts "#{c1}%10s#{c0}  %s" % [ what, cmd ]
  end

  # File helpers
  def touch(target)
    say_status :touch, target
    FileUtils.touch target
  end

  def mkdir_p(target)
    return  if File.directory?(target)
    say_status :mkdir, target
    FileUtils.mkdir_p target
  end

  def cp_r(from, target)
    say_status :copy, "#{from} -> #{target}"
    FileUtils.cp_r from, target
  end

  def mv(from, target)
    say_status :move, "#{from} -> #{target}"
    FileUtils.mv from, target
  end
  def rm_rf(target)
    say_status :delete, target
    FileUtils.rm_rf target
  end
end
