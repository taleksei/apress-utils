# coding: utf-8
require "digest/sha1"

module Apress::Utils::Extensions::ActiveRecord::CachedQueries
  extend ActiveSupport::Concern

  c = Rails.application.config
  if c.respond_to?(:perform_caching_queries) && c.perform_caching_queries
    included do
      class_attribute :cached_queries_expires_in
      self.cached_queries_expires_in = nil
    end

    module ClassMethods
      def find_by_sql(sql, binds = [])
        binds_key = binds.map { |x| "#{x[0].name}:#{x[1].to_s}" } * ','
        cache_key = Digest::SHA1.hexdigest("#{query_key(sql, binds.dup)}#{binds_key}")

        records = Rails.cache.fetch(cache_key, expires_in: cached_queries_expires_in) do
          connection.select_all(sanitize_sql(sql), "#{name} Load", binds)
        end

        records.map { |r| instantiate(r) }
      end

      def query_key(sql, binds)
        query = sanitize_sql(sql)
        query_string = query.respond_to?(:ast) ? connection.to_sql(query, binds) : query.to_s
      end
    end
  end
end
