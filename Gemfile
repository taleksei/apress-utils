source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in apress-utils.gemspec

gemspec

if RUBY_VERSION < '2'
  gem 'pg', '< 0.19.0'
  gem 'mime-types', '< 3.0'
  gem 'pry-debugger'
  gem 'nokogiri', '< 1.7.0'
  gem 'public_suffix', '< 1.5.0'
  gem 'addressable', '< 2.4.0'
else
  gem 'test-unit'
  gem 'pry-byebug'
end
