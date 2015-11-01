# coding: utf-8
require 'rails'

require 'action_view'
require 'active_record'
require 'action_dispatch'
require 'authlogic'
require 'string_tools'

module Apress
  module Utils
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/"]

      if Rails::VERSION::STRING < '3.2'
        config.before_initialize do
          cd = File.dirname(__FILE__)
          require cd + '/extensions/active_record/postgresql_patches'
          require cd + '/extensions/rails_patches'
          require cd + '/extensions/tags_patches'
          require cd + '/extensions/content_for_cache'

          ActionView::Helpers::InstanceTag.send :include, ::Apress::Utils::Extensions::ActionView::Helpers::InstanceTag
          ActionView::Helpers::FormBuilder.send :include, ::Apress::Utils::Extensions::ActionView::Helpers::FormBuilder
          ActionView::Resolver.send             :include, ::Apress::Utils::Extensions::ActionView::ResolverSortLocals

          ActionDispatch::Routing::Mapper.send  :include, ::Apress::Utils::Extensions::ActionDispatch::RoutesLoader

          ActiveRecord::Migration.send          :include, ::Apress::Utils::Extensions::ActiveRecord::Migration
          ActiveRecord::MigrationProxy.send     :include, ::Apress::Utils::Extensions::ActiveRecord::MigrationProxy

          Authlogic::ActsAsAuthentic::Login::Config.send :include, ::Apress::Utils::Extensions::Authlogic::Login
        end
      end

      initializer "apress-utils", before: :load_init_rb do |app|
        app.config.query_cache_store = -> { ::Redis.current }
      end

      config.after_initialize do
        Rails.cache.class_eval do
          def clear
            models = ActiveRecord::Base.
              descendants.
              select { |x| x.included_modules.include?(Apress::Utils::Extensions::ActiveRecord::CachedQueries) }

            models.each(&:reset_cached_queries!)
            super
          end
        end
      end
    end
  end
end
