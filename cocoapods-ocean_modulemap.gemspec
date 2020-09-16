# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-ocean_modulemap/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-ocean_modulemap'
  spec.version       = CocoapodsOcean_modulemap::VERSION
  spec.authors       = ['ocean']
  spec.email         = ['849638313@qq.com']
  spec.description   = %q{modulemap}
  spec.summary       = %q{modulemap 文件处理}
  spec.homepage      = 'https://github.com/oceanfive/cocoapods-ocean_modulemap'
  spec.license       = 'MIT'

  # 使用 这种可能会有 ERROR:  While executing gem ... (Gem::InvalidSpecificationException)
  # ["cocoapods-ocean_modulemap-0.0.1.gem"] are not files
  # 错误
  # spec.files         = `git ls-files`.split($/)
  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'rake', '~> 10.0'
end
