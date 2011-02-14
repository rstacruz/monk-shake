require 'ostruct'
require 'yaml'

class Monk::Config < OpenStruct
  def self.filename
    File.expand_path(File.join(%w(~ .monk.conf)))
  end

  def self.load
    if File.file?(filename)
      self.new YAML::load_file(filename)
    else
      self.new
    end
  end

  def initialize(*a)
    super
    self.skeletons ||= Hash.new
    self.skeletons['default'] ||= 'git://github.com/monk/experimental.git'
  end

  def save!
    File.open(self.class.filename, 'w') { |f| f.write YAML::dump(@table) }
  end
end
