# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pulo/version'

Gem::Specification.new do |spec|
  spec.name          = 'pulo'
  spec.version       = Pulo::VERSION
  spec.authors       = ['Andy Fleming']
  spec.email         = ['kabompo@gmail.com']
  spec.summary       = 'Pulo is a (back-of-envelope) calculator for engineering.'
  spec.description   = 'Pulo is a (back-of-envelope) calculator for engineering. It understands physical quantities, their dimensions and units.'
  spec.homepage      = 'https://github.com/AndyFlem/pulo'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.files = Dir['lib/**/*.rb','lib/**/*.yaml']
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_dependency 'descriptive_statistics', '~> 2.5'
end
