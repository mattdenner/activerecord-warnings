# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activerecord-warnings/version"

Gem::Specification.new do |s|
  s.name        = "activerecord-warnings"
  s.version     = Activerecord::Warnings::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthew Denner"]
  s.email       = ["matt.denner@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Adds warnings to ActiveRecord}
  s.description = %q{Adds the ability to have warnings on an ActiveRecord instance which doesn't prevent saving}

  s.rubyforge_project = "activerecord-warnings"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord', '~>2.3.11')
  s.add_development_dependency('rspec')
  s.add_development_dependency('sqlite3-ruby')
end
