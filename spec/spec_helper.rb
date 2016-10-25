# coding: utf-8
require 'bundler/setup'

require 'combustion'

require 'apress/utils'

Combustion.initialize! :all do
  config.perform_caching_queries = true
  config.cache_store = :memory_store
end

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.before do
    Rails.cache.clear
  end
end
