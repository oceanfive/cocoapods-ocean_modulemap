# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-ocean_modulemap/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-ocean_modulemap'
  spec.version       = CocoapodsOcean_modulemap::VERSION
  spec.authors       = ['ocean']
  spec.email         = ['849638313@qq.com']
  spec.description   = %q{A short description of cocoapods-ocean_modulemap.}
  spec.summary       = %q{A longer description of cocoapods-ocean_modulemap.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-ocean_modulemap'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
