# coding: utf-8
require 'rails'

require 'action_view'
require 'active_record'
require 'action_dispatch'
require 'authlogic'

module Apress
  module Utils
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/"]

      config.before_initialize do
        cd = File.dirname(__FILE__)
        require cd + '/extensions/active_record/postgresql_patches'
        require cd + '/extensions/rails_patches'
        require cd + '/extensions/tags_patches'
        require cd + '/extensions/content_for_cache'

        ActionView::Helpers::InstanceTag.send          :include, ::Apress::Utils::Extensions::ActionView::Helpers::InstanceTag
        ActionView::Helpers::FormBuilder.send          :include, ::Apress::Utils::Extensions::ActionView::Helpers::FormBuilder
        ActionView::Resolver.send                      :include, ::Apress::Utils::Extensions::ActionView::ResolverSortLocals

        ActionDispatch::Routing::Mapper.send           :include, ::Apress::Utils::Extensions::ActionDispatch::Routing::Mapper
        ActionDispatch::Routing::Mapper.send           :include, ::Apress::Utils::Extensions::ActionDispatch::RoutesLoader

        ActiveRecord::Migration.send                   :include, ::Apress::Utils::Extensions::ActiveRecord::Migration
        ActiveRecord::MigrationProxy.send              :include, ::Apress::Utils::Extensions::ActiveRecord::MigrationProxy

        Authlogic::ActsAsAuthentic::Login::Config.send :include, ::Apress::Utils::Extensions::Authlogic::Login
      end
    end
  end
end