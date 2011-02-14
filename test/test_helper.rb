require 'cutest'
require 'shellwords'
require 'fileutils'

require File.expand_path('../../lib/monk', __FILE__)
require File.expand_path('../mock', __FILE__)

def monk(cmd)
  $out = ''
  $err = ''

  Monk.run *Shellwords.shellsplit(cmd)
  [$out, $err]
end

def cout
  $out
end

def cerr
  $err
end

prepare do
  # Clear config
  Monk.instance_variable_set :@config, nil
end
