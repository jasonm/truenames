# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'truenames/version'

Gem::Specification.new do |gem|
  gem.name          = "truenames"
  gem.version       = Truenames::VERSION
  gem.authors       = ["Jason Morrison"]
  gem.email         = ["jason.p.morrison@gmail.com"]
  gem.description   = %q{Improve test failure output by introspecting variable names.}
  gem.summary       = %q{Use local variables and expressions to give more information about assertion failures.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
end
