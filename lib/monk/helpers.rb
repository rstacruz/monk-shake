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

  def show_commands(for_tasks)
    for_tasks.each do |name, task|
      err "  %-20s %s" % [ name, task.description ]
    end
  end

  # Loads the monkfile. Used by bin/monk.
  def load_monkfile
    file = find_in_project("Monkfile")

    if file
      load file
      @project = File.dirname(file)
    end
  end

  # Checks if there is a loaded project or not.
  def project?
    ! @project.nil?
  end

  # File expand: fx('~/.cache/monk')
  def fx(path)
    File.expand_path File.join(*path.split('/'))
  end

  def system(cmd)
    say_status :run, cmd
    super
  end

  def say_status(what, cmd)
    c1 = "\033[0;33m"
    c0 = "\033[0;m"
    puts "#{c1}%10s#{c0}  %s" % [ what, cmd ]
  end

  # File helpers
  def mkdir_p(target)
    say_status :mkdir, target
    FileUtils.mkdir_p target
  end

  def cp_r(from, target)
    say_status :copy, "#{from} -> #{target}"
    FileUtils.cp_r from, target
  end

  def rm_rf(target)
    say_status :delete, target
    FileUtils.rm_rf target
  end
end
