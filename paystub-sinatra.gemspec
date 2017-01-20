# coding: utf-8
lib = File.join(File.dirname(File.expand_path(__FILE__)),'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paystub-sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = 'paystub-sinatra'
  spec.version       = Paystub::Sinatra::VERSION
  spec.authors       = ['Ryan Breed']
  spec.email         = ['ryan@cascadefailure.io']

  spec.summary       = %q{ payload stub runtime }
  spec.description   = %q{ you know, for testing }
  spec.homepage      = 'https://github.com/ryanbreed/paystub-sinatra'
  spec.license       = 'MIT'
  spec.metadata['allowed_push_host'] = 'http://none/'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'slim'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday-http-cache'

  spec.add_development_dependency 'shotgun'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
