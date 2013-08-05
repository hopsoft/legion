# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shared/version'

Gem::Specification.new do |spec|
  spec.name          = "legion"
  spec.version       = Shared::VERSION
  spec.authors       = ["Nathan Hopkins"]
  spec.email         = ["natehop@gmail.com"]
  spec.description   = "True concurrent processing power made easy... even for MRI."
  spec.summary       = "True concurrent processing power made easy... even for MRI."
  spec.homepage      = "https://github.com/hopsoft/legion"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]
  spec.test_files    = Dir["test/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

