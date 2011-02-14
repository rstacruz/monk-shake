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
    tmp = File.expand_path("../tmp", __FILE__)
    FileUtils.mkdir tmp  unless File.directory?(tmp)
    File.join(tmp, name)
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
