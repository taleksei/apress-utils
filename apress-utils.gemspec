# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apress/utils/version'

Gem::Specification.new do |spec|
  spec.metadata['allowed_push_host'] = 'https://gems.railsc.ru'
  spec.name          = 'apress-utils'
  spec.version       = Apress::Utils::VERSION
  spec.authors       = ['Merkushin']
  spec.email         = ['merkushin.m.s@gmail.com']
  spec.summary       = %q{apress-utils}
  spec.description   = %q{apress-utils}
  spec.homepage      = 'https://github.com/abak-press/apress-utils'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.1.12', '< 4.0'
  spec.add_runtime_dependency 'authlogic', '~> 3'
  spec.add_runtime_dependency 'pg'
  spec.add_runtime_dependency 'string_tools', '>= 0.2.0'
  spec.add_runtime_dependency "redis"

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '>= 0.5.2'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency "mock_redis", ">= 0.14"
  spec.add_development_dependency "test_after_commit"
  spec.add_development_dependency "pry-debugger"
end
