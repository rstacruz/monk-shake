task :test do
  require 'cutest'
  ENV['DEBUG'] = '1'
  Cutest.run(Dir["test/**/*_test.rb"])
end

task :default => :test
