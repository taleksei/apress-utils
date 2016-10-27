source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in apress-utils.gemspec

gemspec

if RUBY_VERSION < '2'
  gem 'pg', '< 0.19.0'
  gem 'pry-debugger'
else
  gem 'test-unit'
  gem 'pry-byebug'
end
