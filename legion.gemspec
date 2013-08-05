# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'legion/version'

Gem::Specification.new do |gem|
  gem.required_ruby_version = ">= 2.0.0"
  gem.name          = "legion"
  gem.version       = Legion::VERSION
  gem.authors       = ["Nathan Hopkins"]
  gem.email         = ["natehop@gmail.com"]
  gem.description   = "Concurrent processing made easy... even for MRI."
  gem.summary       = "Concurrent processing made easy... even for MRI."
  gem.homepage      = "https://github.com/hopsoft/legion"
  gem.license       = "MIT"

  gem.files         = Dir["lib/**/*.rb", "bin/*", "[A-Z].*"]
  gem.test_files    = Dir["test/**/*.rb"]
  gem.require_paths = ["lib"]

  gem.executables = "legion_demo"

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
end

