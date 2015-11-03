# coding: utf-8
require 'bundler/setup'

require 'combustion'

require 'apress/utils'

require "redis"
require "mock_redis"
redis = MockRedis.new
Redis.current = redis

Combustion.initialize! :all do
  config.perform_caching_queries = true
  config.cache_store = :memory_store
  config.query_cache_store = -> { redis }
end

require 'rspec/rails'
require "pry-debugger"
require "test_after_commit"

RSpec.configure do |config|
  config.before do
    Redis.current.flushdb
  end
end
