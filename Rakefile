$:.unshift File.expand_path('../test', __FILE__)

task :test do
  require 'cutest'
  Cutest.run(Dir["test/**/*_test.rb"])
end

task :default => :test
