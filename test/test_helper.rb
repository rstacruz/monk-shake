require 'cutest'
require 'shellwords'
require 'fileutils'

require File.expand_path('../../lib/monk', __FILE__)
require File.expand_path('../mock', __FILE__)

def monk(cmd)
  $out = ''
  $err = ''

  Monk.load_monkfile
  Monk.run *Shellwords.shellsplit(cmd)
end

def cout
  $out
end

def cerr
  $err
end

def assert_invalid
  assert cout.empty?
  assert cerr.include?('Invalid usage')
end

def assert_successful_init(path)
  assert cout.include?("Success! You've created a new project")
  assert cerr.empty?
  assert File.directory?(path)
  assert File.file?(File.join(path, 'Monkfile'))
  assert File.file?(File.join(path, 'init.rb'))
  assert !File.exists?(File.join(path, '.git'))
end

tmp_path = File.expand_path('../tmp', __FILE__)
FileUtils.mkdir_p tmp_path

prepare do
  # Clear config
  Dir.chdir tmp_path
  Monk.instance_variable_set :@config, nil
  FileUtils.rm_rf 'Monkfile'
end
