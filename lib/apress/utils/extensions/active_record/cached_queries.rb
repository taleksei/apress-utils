# coding: utf-8
require "digest/sha1"

module Apress::Utils::Extensions::ActiveRecord::CachedQueries
  extend ActiveSupport::Concern

  c = Rails.application.config
  if c.respond_to?(:perform_caching_queries) && c.perform_caching_queries
    included do
      class_attribute :cached_queries_expires_in
      self.cached_queries_expires_in = nil

      class_attribute :cached_queries_with_tags
      self.cached_queries_with_tags = nil

      after_save { |record| record.class.reset_cached_queries! }
      after_destroy { |record| record.class.reset_cached_queries! }
      after_rollback { |record| record.class.reset_cached_queries! }
    end

    module ClassMethods
      def find_by_sql(sql, binds = [])
        return super if @without_cache

        binds_key = binds.map { |x| "#{x[0].name}:#{x[1].to_s}" } * ','
        cache_key = Digest::SHA1.hexdigest("#{query_key(sql, binds.dup)}#{binds_key}")
        cache_key = "#{self.to_s.demodulize}:#{cache_key}"

        records = cached_query_store.fetch(cache_key, cache_options) do
          connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
        end

        records.map { |r| instantiate(r) }
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
        cached_query_store.delete_by_tags(cache_tag)
      end

      def cache_options
        return @cache_options if defined?(@cache_options)

        @cache_options = {}
        @cache_options[:tags] = cache_tag if cached_queries_with_tags
        @cache_options[:expires_in] = cached_queries_expires_in if cached_queries_expires_in
        @cache_options
      end

      def cached_query_store
        @cached_query_store ||= begin
          config = Rails.application.config
          config.respond_to?(:cached_query_store) && config.cached_query_store || Rails.cache
        end
      end
    end
  end
end
