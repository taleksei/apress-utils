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
      cd = File.dirname(__FILE__)
      require cd + '/extensions/uri'

      if Rails::VERSION::STRING < '3.2'
        config.before_initialize do
          require cd + '/extensions/active_record/postgresql_patches'
          require cd + '/extensions/rack_patches'
          require cd + '/extensions/rails_patches'
          require cd + '/extensions/tags_patches'
          require cd + '/extensions/content_for_cache'
          require cd + '/extensions/readthis/cache'

          ActionView::Helpers::InstanceTag.send :include, ::Apress::Utils::Extensions::ActionView::Helpers::InstanceTag
          ActionView::Helpers::FormBuilder.send :include, ::Apress::Utils::Extensions::ActionView::Helpers::FormBuilder
          ActionView::Resolver.send             :include, ::Apress::Utils::Extensions::ActionView::ResolverSortLocals

          ActionDispatch::Routing::Mapper.send  :include, ::Apress::Utils::Extensions::ActionDispatch::RoutesLoader

          ActiveRecord::Base.send               :include, ::Apress::Utils::Extensions::ActiveRecord::Pluck::Base
          ActiveRecord::Associations::CollectionProxy.send(
            :include,
            ::Apress::Utils::Extensions::ActiveRecord::Pluck::Associations::CollectionProxy
          )
          ActiveRecord::Relation.send           :include, ::Apress::Utils::Extensions::ActiveRecord::Pluck::Relation

          ActiveRecord::Migration.send          :include, ::Apress::Utils::Extensions::ActiveRecord::Migration
          ActiveRecord::MigrationProxy.send     :include, ::Apress::Utils::Extensions::ActiveRecord::MigrationProxy

          Authlogic::ActsAsAuthentic::Login::Config.send :include, ::Apress::Utils::Extensions::Authlogic::Login

          Readthis::Cache.send(:include, ::Apress::Utils::Extensions::Readthis::Cache)
        end
      end
    end
  end
end
