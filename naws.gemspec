# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "naws/version"

Gem::Specification.new do |s|
  s.name        = "naws"
  s.version     = Naws::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthew Boeh"]
  s.email       = ["matthew.boeh@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A (currently experimental) library providing tools to interact with Amazon Web Services}
  s.description = %q{A (currently experimental) library providing tools to interact with Amazon Web Services}

  s.rubyforge_project = "naws"
  s.add_dependency 'builder', '~> 3.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
