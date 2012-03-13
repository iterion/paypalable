# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paypalable/version"

Gem::Specification.new do |s|
  s.name        = "paypalable"
  s.version     = Paypalable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Sunderland", "Tommy Chheng"]
  s.email       = ["iterion@gmail.com", "tommy.chheng@gmail.com"]
  s.homepage    = "http://github.com/iterion/paypalable"
  s.summary     = "ActiveRecord extension for Paypal's Adaptive Payments API"
  s.description = "ActiveRecord extension for Paypal's Adaptive Payments API"

  s.add_dependency("json", "~>1.6.0")
  s.add_dependency("rake", "~>0.8")

  s.rubyforge_project = "paypalable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
