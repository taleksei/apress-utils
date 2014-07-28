# coding: utf-8
require 'bundler/setup'

require 'combustion'

require 'apress/utils'

Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
  config.backtrace_exclusion_patterns = [/lib\/rspec\/(core|expectations|matchers|mocks)/]
end
