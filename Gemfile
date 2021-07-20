# frozen_string_literal: true
source 'https://gems.railsc.ru'
source 'https://rubygems.org'

# Specify your gem's dependencies in apress-utils.gemspec

gemspec

if RUBY_VERSION < '2.3'
  gem 'nokogiri', '< 1.10.0', require: false
  gem 'pry-byebug', '< 3.7.0', require: false
  gem 'redis', '< 4.1.2', require: false
end

# NameError: uninitialized constant Pry::Command::ExitAll при попытке выполнить require 'pry-byebug'
gem 'pry', '< 0.13.0', require: false
gem 'rspec-rails', '~> 3.9.1', require: false
