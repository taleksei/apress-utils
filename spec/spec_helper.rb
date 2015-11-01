# coding: utf-8
require 'bundler/setup'

require 'combustion'

require 'apress/utils'

Combustion.initialize! :all do
  config.perform_caching_queries = true
  config.cache_store = :memory_store
end

require 'rspec/rails'
require "pry-debugger"
require "test_after_commit"
require "redis"
require "mock_redis"
redis = MockRedis.new
Redis.current = redis

RSpec.configure do |config|
  config.before do
    Redis.current.flushdb
  end
end
