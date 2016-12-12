# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'operating_hours/version'

Gem::Specification.new do |spec|
  spec.name          = 'operating_hours'
  spec.version       = OperatingHours::VERSION
  spec.authors       = ['Jordi Noguera']
  spec.email         = ['jordinoguera83@gmail.com']

  spec.summary       = %q{Time calculations based on business hours}
  spec.homepage      = 'https://github.com/spreemo/operating_hours'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
