# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logripper/version'

Gem::Specification.new do |spec|
  spec.name          = "logripper"
  spec.version       = Logripper::VERSION
  spec.authors       = ["Ben Cates"]
  spec.email         = ["ben@ideum.com"]
  spec.description   = %q{Tool for parsing metrics from logs}
  spec.summary       = %q{Tool for parsing metrics from logs}
  spec.homepage      = "https://github.com/ideum/logripper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency "thor", "~> 0.18.1"
end
