# coding: utf-8
require "digest/sha1"

module Apress::Utils::Extensions::ActiveRecord::CachedQueries
  extend ActiveSupport::Concern

  c = Rails.application.config
  if c.respond_to?(:perform_caching_queries) && c.perform_caching_queries
    included do
      after_save { |record| record.class.reset_cached_queries! }
      after_destroy { |record| record.class.reset_cached_queries! }
      after_rollback { |record| record.class.reset_cached_queries! }
    end

    module ClassMethods
      def find_by_sql(sql, binds = [])
        binds_key = binds.map { |x| "#{x[0].name}:#{x[1].to_s}" } * ','
        cache_key = Digest::SHA1.hexdigest("#{query_key(sql, binds.dup)}#{binds_key}")

        if records = query_cache.hget(group_query_key, cache_key)
          records = Marshal.load(records)
        else
          records = connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
          query_cache.hset(group_query_key, cache_key, Marshal.dump(records))
        end

        records.map { |record| instantiate(record) }
      end

      def reset_cached_queries!
        query_cache.del(group_query_key)
      end

      private

      def group_query_key
        @query_key ||= "#{table_name}-query-cache"
      end

      def query_key(sql, binds)
        query = sanitize_sql(sql)
        query_string = query.respond_to?(:ast) ? connection.to_sql(query, binds) : query.to_s
      end

      def query_cache
        @query_cache ||= Rails.application.config.query_cache_store.call
      end
    end
  end
end
