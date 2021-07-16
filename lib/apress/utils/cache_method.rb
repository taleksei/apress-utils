# coding: utf-8
# frozen_string_literal: true
# It’s like alias_method, but it’s cache_method!
# Lets you cache the results of calling methods given their arguments.
# Like memoization, but stored in Memcached, Redis, etc. so that the cached
# results can be shared between processes and hosts.
#
# Usage:
#class A
#   include Apress::Utils::CacheMethod
#   def compute
#     sleep 1
#     "Result"
#   end
#   cache_method :compute
#end
module Apress::Utils
  module CacheMethod
    extend ActiveSupport::Concern

    module ClassMethods
      # Makes method cacheable
      # Valid options are the same as for Rails.cache.fetch except :engine option
      # Example:
      # cache_method :compute, :expires_in => 20.minutes, :engine => Rails.cache
      # cache_method :another_compute, :race_condition_ttl => 10, :engine => Redis.new
      #
      # Apply it <b>before</b> +memoize+!!!
      def cache_method(method_id, options = {})
        return unless caching_enabled?

        method_id = method_id.to_sym
        method_uncached = "__uncached_#{method_id}"

        # check validity
        raise "Method #{method_id} already cached" if method_defined?(method_uncached)

        # save options
        if engine = options.delete(:engine)
          cache_engine_for method_id, engine
        end
        cache_options_for method_id, options

        # rename uncached method
        alias_method method_uncached, method_id
        # make uncached method private
        private(method_uncached)

        # create cached method
        class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{method_id}(*args, &block)
            cache_key_parts = [self, :#{method_id}, *args].map { |arg| ActiveSupport::Cache.expand_cache_key(arg) }
            cache_key = ActiveSupport::Cache.expand_cache_key(cache_key_parts)
            cache = self.class.send(:cache_engine_for, :#{method_id})
            options = self.class.send(:cache_options_for, :#{method_id})

            cache.fetch(cache_key, options) do
              #{method_uncached}(*args, &block)
            end
          end
        EOS
      end

      private
      def caching_enabled?
        Rails.application.config.action_controller.perform_caching && Rails.cache
      end

      # internal
      def cache_options_for(method_id, options = nil)
        @method_cache_options ||= {}

        if options.nil?
          @method_cache_options[method_id.to_sym]
        else
          @method_cache_options[method_id.to_sym] = options
        end
      end

      # internal
      def cache_engine_for(method_id, engine = nil)
        @method_cache_engines ||= {}

        if engine.nil?
          @method_cache_engines[method_id.to_sym] || Rails.cache
        else
          @method_cache_engines[method_id.to_sym] = engine
        end
      end
    end
  end
end