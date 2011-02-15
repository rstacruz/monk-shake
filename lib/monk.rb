$:.push *Dir[File.expand_path('../../vendor/*/lib', __FILE__)]

require 'fileutils'
require 'shake'

class Monk < Shake
  VERSION = "1.0.0.something"
  PREFIX  = File.expand_path('../monk', __FILE__)

  autoload :Helpers,      "#{PREFIX}/helpers"
  autoload :InitHelpers,  "#{PREFIX}/init_helpers"
  autoload :Config,       "#{PREFIX}/config"

  extend Helpers
  extend InitHelpers

  task(:init) do
    name   = params.extract('-s') || 'default'
    wrong_usage  if params.size != 1

    target = params.shift

    unless config.skeletons[name]
      pass "No such skeleton: #{name}\n" +
           "Type `#{executable} list` for a list of known skeletons."
    end

    if File.exists?(target)
      pass "Error: the target directory already exists."
    end

    skeleton_files = cache_skeleton(name)
    pass "Error: can't retrieve the skeleton files."  unless skeleton_files
    cp_r skeleton_files, target

    in_path (target) {
      rm_rf '.git'
      touch 'Monkfile'
      system_q "rvm #{RUBY_VERSION}@#{target} --rvmrc --create"  if rvm?
      system_q "rvm rvmrc trust"  if rvm?
    }

    puts 
    puts "Success! You've created a new project."
    puts "Get started now:"
    puts
    puts "  $ cd #{target}"
    puts "  $ #{executable} start"
    puts

    if rvm?
      puts "An RVM gemset @#{target} has been created for you."
      puts
    end
  end

  task(:install) do
    manifest = '.gems'

    pass "This project does not have a .gems manifest."  unless File.exists?(manifest)

    gems = File.read(manifest).split("\n")

    gems.reject! { |name| name =~ /^\s*(#|$)/ }
    pass "The .gems manifest is empty."  unless gems.any?

    gems.reject! { |name| has_gem? name }
    pass "All good! You have all needed gems installed."  unless gems.any?

    unless rvm?
      err "Tip: RVM is a great way to manage gems across multiple projects."
      err "See http://rvm.beginrescueend.com for more info."
      err
    end

    gems.each { |name| system "gem install #{name}" }
  end

  task(:unpack) do
    ensure_rvm or pass
    system "rvm rvmrc load"
    system "rvm gemset unpack vendor"
  end

  task(:lock) do
    ensure_rvm or pass
    system "rvm rvmrc load"
    system "rvm gemset export .gems"
  end

  task(:add) do
    wrong_usage  unless params.size == 2
    name, repo = params

    existed = !!config.skeletons[name]

    config.skeletons[name] = repo
    config.save!

    if existed
      err "Updated skeleton #{name}."
    else
      err "Added skeleton #{name}."
    end
    err "Create a new project from this skeleton by typing: #{executable} init NAME -s #{name}"
  end

  task (:rm) do
    wrong_usage  if params.size != 1
    name = params.first

    if name == 'default'
      pass "You can't delete the default skeleton."
    elsif config.skeletons[name]
      config.skeletons.delete name.to_s
      config.save!

      err "Removed #{name}."
    else
      err "No such skeleton."
      err "See `#{executable} list` for a list of skeletons."
    end
  end

  task(:purge) do
    rm_rf cache_path  if File.directory?(cache_path)
    err "Monk cache clear."
  end

  task(:list) do
    wrong_usage  if params.any?

    puts "Available skeletons:"
    puts
    config.skeletons.each do |name, repo|
      puts "  %-20s %s" % [ name, repo ]
    end
    puts
    puts "Create a new project by typing `#{executable} init NAME -s SKELETON`."
  end

  task(:help) do
    show_help_for(params.first) and pass  if params.any?

    show_task = Proc.new { |name, t| err "  %-20s %s" % [ t.usage || name, t.description ] }

    err "Usage: #{executable} <command>"
    err

    if project?
      err "Dependency commands:"
      tasks_for(:dependency).each &show_task
      err
      if other_tasks.any?
        err "Project commands:"
        other_tasks.each &show_task
        err
      end
    else
      err "Commands:"
      tasks_for(:init).each &show_task
      err
      err "Skeleton commands:"
      tasks_for(:skeleton).each &show_task
      err
    end

    err "Other commands:"
    tasks_for(:help).each &show_task

    unless project?
      err
      err "Get started by typing:"
      err "  $ #{executable} init my_project"
      err
      err "Type `#{executable} help COMMAND` for additional help on a command."
      err "See http://www.monkrb.com for more information."
    end
  end

  task(:version) do
    puts "Monk version #{VERSION}"
  end

  invalid do
    task = task(command)
    if task
      err "Invalid usage."
      err "Try: #{executable} #{task.usage}"
      err
      err "Type `#{executable} help` for more info."
    else
      err "Invalid command: #{command}"
      err "Type `#{executable} help` for more info."
    end
  end

  # Task metadata
  default :help

  task(:init).tap do |t|
    t.category    = :init
    t.usage       = "init NAME"
    t.description = "Starts a Monk project"
    t.help = %{
      Usage:
      
          #{executable} init NAME [-s SKELETON]
      
      Initializes a Monk application of a given name.
      
      You may use a different skeleton by specifying `-s SKELETON` where
      SKELETON refers to the name or URL of the skeleton. If this isn't specified,
      the default skeleton is used.
      
      Examples
      --------
      
      This creates a new Monk/Sinatra application in the directory `myapp`.
      
          #{executable} init myapp
      
      This creates a new application based on the skeleton in the given Git repo.
      
          #{executable} add myskeleton https://github.com/rstacruz/myskeleton.git
          #{executable} init myapp -s myskeleton
    }.gsub(/^ {6}/,'').strip.split("\n")
  end

  task(:add).tap do |t|
    t.category    = :skeleton
    t.usage       = "add NAME URL"
    t.description = "Adds a skeleton"
  end

  task(:rm).tap do |t|
    t.category    = :skeleton
    t.usage       = "rm NAME"
    t.description = "Removes a skeleton"
  end

  task(:list).tap do |t|
    t.category    = :skeleton
    t.description = "Lists known skeletons"
  end

  task(:purge).tap do |t|
    t.category    = :skeleton
    t.description = "Clears the skeleton cache"
  end

  task(:help).tap do |t|
    t.category    = :help
    t.description = "Shows a list of commands"
  end

  task(:version).tap do |t|
    t.category    = :help
    t.description = "Shows the Monk version"
  end

  task(:install).tap do |t|
    t.category    = :dependency
    t.description = "Install gems in the .gems manifest file"
    t.help = %{
      Usage:

          #{executable} install
          
      Loads the given gemset name of your project, and installs the gems
      needed by your project.

      Gems are specified in the `.gems` file. This is created using
      `#{executable} lock`.

      The gemset name is then specified in `.rvmrc`, which is created upon
      creating your project with `#{executable} init`.
    }.gsub(/^ {6}/,'').strip.split("\n")
  end

  task(:unpack).tap do |t|
    t.category    = :dependency
    t.description = "Freeze gem dependencies into vendor/"
    t.help = %{
      Usage:

          #{executable} unpack

      Freezes the current gem dependencies of your project into the `vendor/`
      path of your project.

      This allows you to commit the gem contents into your project's repository.
      This way, deploying your project elsewhere would not need `monk install`
      or `gem install` to set up the dependencies.
    }.gsub(/^ {6}/,'').strip.split("\n")
  end

  task(:lock).tap do |t|
    t.category    = :dependency
    t.description = "Lock gem dependencies into a .gems manifest file"
    t.help = %{
      Usage:

          #{executable} lock
          
      Locks the current gem version dependencies of your project into the gem
      manifest file.

      This creates the `.gems` file for your project, which is then used by
      `#{executable} install`.
    }.gsub(/^ {6}/,'').strip.split("\n")
  end
end
