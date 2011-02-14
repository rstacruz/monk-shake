#!/usr/bin/env ruby
require File.expand_path('../../vendor/clap/lib/clap', __FILE__)
require 'fileutils'

class Monk
  VERSION = "1.0.0.clap"
  PREFIX  = File.expand_path('../monk', __FILE__)

  autoload :Helpers,      "#{PREFIX}/helpers"
  autoload :InitHelpers,  "#{PREFIX}/init_helpers"
  autoload :Config,       "#{PREFIX}/config"

  include Helpers
  include InitHelpers

  attr_accessor :skeleton

  def initialize(argv)
    @argv = argv
  end

  def init(target)
    name = skeleton || 'default'

    unless config.skeletons[name]
      pass "No such skeleton: #{name}\n" +
           "Type `#{executable} list` for a list of known skeletons."
    end

    if File.exists?(target)
      pass "Error: the target directory already exists."
    end

    skeleton_files = cache_skeleton(name)
    cp_r skeleton_files, target

    in_path (target) {
      rm_rf '.git'
      system 'touch "Monkfile"'
      system_q "rvm 1.9.2@#{target} --rvmrc --create"  if rvm?
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

  def add(name, repo)
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
  
  def rm(name)
    if name == 'default'
      err "You can't delete the default skeleton."
      return
    elsif config.skeletons[name]
      config.skeletons.delete name.to_s
      config.save!

      err "Removed #{name}."
    else
      err "No such skeleton."
      err "See `#{executable} list` for a list of skeletons."
    end
  end

  def purge
    rm_rf cache_path  if File.directory?(cache_path)
    err "Monk cache clear."
  end

  def list
    puts "Available skeletons:"
    puts
    config.skeletons.each do |name, repo|
      puts "  %-20s %s" % [ name, repo ]
    end
    puts
    puts "Create a new project by typing `#{executable} init NAME -s SKELETON`."
  end

  def version
    puts "Monk version #{VERSION}"
  end

  def install
    manifest = '.gems'

    err("This project does not have a .gems manifest.") and return  unless File.exists?(manifest)

    gems = File.read(manifest).split("\n")

    gems.reject! { |name| name =~ /^\s*(#|$)/ }
    err("The .gems manifest is empty.") and return  unless gems.any?

    gems.reject! { |name| has_gem? name }
    err("All good! You have all needed gems installed.") unless gems.any?

    unless rvm?
      err "Tip: RVM is a great way to manage gems across multiple projects."
      err "See http://rvm.beginrescueend.com for more info."
      err
    end

    gems.each { |name| system "gem install #{name}" }
  end

  def unpack
    ensure_rvm or pass
    system "rvm rvmrc load"
    system "rvm gemset unpack vendor"
  end

  def lock
    ensure_rvm or pass
    system "rvm rvmrc load"
    system "rvm gemset export .gems"
  end

  def invalid
    puts "Invalid usage."
    puts "Type '#{executable} help' for more info."
  end

  def help
    err "Usage: #{executable} <command>"
    err ""
    err "Commands:"
    err "  init NAME            Starts a Monk project"
    err ""
    err "Skeleton commands:"
    err "  add NAME URL         Adds a skeleton"
    err "  rm NAME              Removes a skeleton"
    err "  purge                Clears the skeleton cache"
    err "  list                 Lists known skeletons"
    err ""
    err "Other commands:"
    err "  help                 Shows a list of commands"
    err "  version              Shows the Monk version"
    err ""
    err "Get started by typing:"
    err "  $ #{executable} init my_project"
    err ""
    err "See http://www.monkrb.com for more information."
  end

  def run!(argv=@argv)
    begin
      return help  if argv.empty?

      x = Clap.run argv,
        '-s'      => method(:skeleton=),
        # Init
        'init'    => method(:init),
        # Skeletons
        'add'     => method(:add),
        'rm'      => method(:rm),
        'purge'   => method(:purge),
        'list'    => method(:list),
        # Dependencies
        'install' => method(:install),
        'unpack'  => method(:unpack),
        'lock'    => method(:lock),
        # Other
        'help'    => method(:help),
        'version' => method(:version)

    rescue ArgumentError
      invalid
    end
  end

  def err(str)
    $stderr.write "#{str}\n"
  end

  def executable
    File.basename $0
  end
end

