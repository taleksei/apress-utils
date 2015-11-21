# coding: utf-8
module Apress::Utils::Extensions::ActiveRecord::CachedQueries
  extend ActiveSupport::Concern

  c = Rails.application.config
  if c.respond_to?(:perform_caching_queries) && c.perform_caching_queries
    included do
      after_save { |m| m.class.reset_cached_queries! }
    end

    module ClassMethods
      def find_by_sql(sql, binds = [])
        binds_key = binds.map { |x| "#{x[0].name}:#{x[1].to_s}" } * ','
        cache_key = Digest::MD5.hexdigest("#{query_key(sql, binds.dup)}#{binds_key}")

        records = Rails.cache.fetch(cache_key, tags: [cache_tag]) do
          connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
        end

        records.map { |r| instantiate(r) }
      end

      def reset_cached_queries!
        Rails.cache.delete_by_tags([cache_tag])
      end

      def query_key(sql, binds)
        query = sanitize_sql(sql)
        query_string = query.respond_to?(:ast) ? connection.to_sql(query, binds) : query.to_s
      end

      def cache_tag
        "#{table_name}-queries"
      end
    end
  end
end
