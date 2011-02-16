# Silly mocking

# Capture output and input
class << Monk
  def puts(what=nil)
    $out << "#{what}\n"
  end

  def err(what=nil)
    $err << "#{what}\n"
  end
end

# Caching will always happen in a temp folder
module Monk::InitHelpers
  def cache_path(name=nil)
    File.expand_path("../tmp/#{name}", __FILE__)
  end

  def git_clone(repo, path)
    FileUtils.mkdir_p path
    FileUtils.touch File.join(path, 'Monkfile')
    FileUtils.touch File.join(path, 'init.rb')
    say_status :run, "git clone --depth 1 #{repo} #{path}"
  end
end

module Monk::RvmHelpers
  def rvm?
    false
  end
end

# Config will never load the config file
class Monk::Config
  def self.load
    self.new
  end

  def save!
  end
end
