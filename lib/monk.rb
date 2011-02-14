require 'fileutils'

require File.expand_path(File.join(File.dirname(__FILE__), %w(.. vendor shake lib shake)))
require File.expand_path(File.join(File.dirname(__FILE__), %w(.. vendor clap lib clap)))

class Monk < Shake
  VERSION = "1.0.0.something"
  PREFIX  = File.expand_path(File.join(File.dirname(__FILE__), 'monk'))

  autoload :Helpers,      "#{PREFIX}/helpers"
  autoload :InitHelpers,  "#{PREFIX}/init_helpers"
  autoload :Config,       "#{PREFIX}/config"

  extend Helpers
  extend InitHelpers

  task(:init) do
    @options = { :skeleton => 'default' }
    target, _ = Clap.run params,
      "-s" => lambda { |s| @options[:skeleton] = s }

    wrong_usage  if target.nil?

    name = @options[:skeleton]
    repo = config.skeletons[name]

    unless repo
      pass "No such skeleton: #{@options[:skeleton]}\n" +
           "Type `monk list` for a list of known skeletons."
    end

    if File.exists?(target)
      pass "Error: the target directory already exists."
    end

    skeleton_files = cache_skeleton(name)
    cp_r skeleton_files, target
    system "touch #{File.join(target, 'Monkfile')}"  # Temporary!

    puts 
    puts "Success! You've created a new project."
    puts "Get started now:"
    puts
    puts "  $ cd #{target}"
    puts "  $ monk start"
    puts
  end

  task(:add) do
    wrong_usage  unless params.size == 2
    name, repo = params

    existed = !! config.skeletons[name]

    config.skeletons[name] = repo
    config.save!

    if existed
      err "Added skeleton #{name}."
    else
      err "Updated skeleton #{name}."
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
    show_task = Proc.new { |name, t| err "  %-20s %s" % [ t.usage || name, t.description ] }

    err "Usage: #{executable} <command>"
    err

    if project?
      err "Project commands:"
      other_tasks.each &show_task
      err
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

  task(:help).tap do |t|
    t.category    = :help
    t.description = "Shows a list of commands"
  end

  task(:version).tap do |t|
    t.category    = :help
    t.description = "Shows the Monk version"
  end
end
