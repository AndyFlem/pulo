# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pulo/version'

Gem::Specification.new do |spec|
  spec.name          = 'pulo'
  spec.version       = Pulo::VERSION
  spec.authors       = ['Andy Fleming']
  spec.email         = ['andy@ulendo.com']
  spec.summary       = 'An engineering toolbox'
  spec.description   = 'An engineering toolbox'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
