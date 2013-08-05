# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'legion/version'

Gem::Specification.new do |spec|
  spec.name          = "legion"
  spec.version       = Legion::VERSION
  spec.authors       = ["Nathan Hopkins"]
  spec.email         = ["natehop@gmail.com"]
  spec.description   = "Concurrent processing made easy... even for MRI."
  spec.summary       = "Concurrent processing made easy... even for MRI."
  spec.homepage      = "https://github.com/hopsoft/legion"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]
  spec.test_files    = Dir["test/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

