# coding: utf-8
require "digest/sha1"
require "lru_redux"

module Apress::Utils::Extensions::ActiveRecord::CachedQueries
  extend ActiveSupport::Concern

  config = Rails.application.config
  if config.respond_to?(:perform_caching_queries) && config.perform_caching_queries
    included do
      class_attribute :cached_queries_expires_in
      self.cached_queries_expires_in = nil

      class_attribute :cached_queries_with_tags
      self.cached_queries_with_tags = nil

      class_attribute :cached_queries_local_store_size
      self.cached_queries_local_store_size = 100

      after_save { |record| record.class.reset_cached_queries! }
      after_destroy { |record| record.class.reset_cached_queries! }
      after_rollback { |record| record.class.reset_cached_queries! }

      class CachedQueriesStore
        attr_reader :options
        attr_reader :local_store_size

        def initialize(options)
          @options = options.except(:local_store_size)
          @local_store_size = options.fetch(:local_store_size)
        end

        def fetch(key, &block)
          local_store.getset(key) do
            redis_store.fetch(key, options) do
              yield
            end
          end
        end

        def reset_local_store
          local_store.clear
        end

        def reset_by_tag(tag)
          redis_store.delete_by_tags(tag)
          reset_local_store
        end

        private

        def local_store
          @local_store ||=
            if @local_store_size > 0
              ::LruRedux::TTL::Cache.new(@local_store_size, options[:expires_in] || :none)
            else
              NullStore.new
            end
        end

        def redis_store
          @redis_store ||= begin
            config = Rails.application.config
            config.respond_to?(:cached_query_store) && config.cached_query_store || Rails.cache
          end
        end

        class NullStore
          def getset(_); yield; end
          def clear; end
        end
      end
    end

    module ClassMethods
      def find_by_sql(sql, binds = [])
        return super if @without_cache

        binds_key = binds.map { |x| "#{x[0].name}:#{x[1].to_s}" } * ','
        cache_key = Digest::SHA1.hexdigest("#{query_key(sql, binds.dup)}#{binds_key}")
        cache_key = "#{self.to_s.demodulize}:#{cache_key}"

        records = cached_queries_store.fetch(cache_key) do
          connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
        end

        records.map { |record| instantiate(record) }
      end

      def query_key(sql, binds)
        query = sanitize_sql(sql)
        query.respond_to?(:ast) ? connection.to_sql(query, binds) : query.to_s
      end

      def run_without_cache
        @without_cache = true
        yield
      ensure
        @without_cache = false
      end

      def cache_tag
        "#{table_name}-queries"
      end

      def reset_cached_queries!
        return unless cached_queries_with_tags
        cached_queries_store.reset_by_tag(cache_tag)
      end

      def reset_local_query_cache
        cached_queries_store.reset_local_store
      end

      def cache_options
        return @cache_options if defined?(@cache_options)

        @cache_options = {}
        @cache_options[:tags] = cache_tag if cached_queries_with_tags
        @cache_options[:expires_in] = cached_queries_expires_in if cached_queries_expires_in
        @cache_options[:local_store_size] = cached_queries_local_store_size
        @cache_options
      end

      def cached_queries_store
        @cached_queries_store ||= CachedQueriesStore.new(cache_options)
      end
    end
  end
end
