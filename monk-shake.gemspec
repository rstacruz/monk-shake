Gem::Specification.new do |s|
  s.name = "monk-shake"
  s.version = "1.0.0.pre2"
  s.summary = "Monk the Sinatra glue framework -- reloaded"
  s.description = "Monk lets you build Sinatra applications quickly and painlessly by letting it set up the directory structure for you. Monk-shake is a rewritten version of Monk that uses the Shake gem."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://www.github.com/rstacruz/monk-shake"
  s.files = ["bin/monk", "lib/monk", "lib/monk/config.rb", "lib/monk/file_helpers.rb", "lib/monk/helpers.rb", "lib/monk/init_helpers.rb", "lib/monk/rvm_helpers.rb", "lib/monk.rb", "test/add_test.rb", "test/help_test.rb", "test/init_test.rb", "test/lock_test.rb", "test/mock.rb", "test/test_helper.rb", "test/tmp", "test/tmp/default", "test/tmp/default/init.rb", "test/tmp/default/Monkfile", "test/tmp/x", "test/tmp/x/init.rb", "test/tmp/x/Monkfile", "HISTORY.md", "README.md", "Rakefile"]
  s.executables.push("monk")

  s.add_dependency("shake", "~> 0.1.1")
end
