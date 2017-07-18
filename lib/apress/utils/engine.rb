# coding: utf-8
require 'rails'

require 'action_view'
require 'active_record'
require 'active_record/connection_adapters/postgresql_adapter'
require 'action_dispatch'
require 'string_tools'

module Apress
  module Utils
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/"]
      cd = File.dirname(__FILE__)

      require cd + '/extensions/uri/parsers_overrides'

      if RUBY_VERSION < '2.2'
        URI::Parser.send(:include, ::Apress::Utils::Extensions::Uri::ParsersOverrides)
      else
        URI::RFC2396_Parser.send(:include, ::Apress::Utils::Extensions::Uri::ParsersOverrides)
        URI::RFC3986_Parser.send(:include, ::Apress::Utils::Extensions::Uri::ParsersOverrides)
      end

      config.before_initialize do
        if Utils.rails32? || Utils.rails40?
          ActionView::Helpers::FormBuilder.include(::Apress::Utils::Extensions::ActionView::Helpers::FormBuilder)
          ActionDispatch::Routing::Mapper.include(::Apress::Utils::Extensions::ActionDispatch::RoutesLoader)
        end

        if Utils.rails40?
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(
            Apress::Utils::Extensions::ActiveRecord::ConnectionAdapters::Rails40::PostgreSQLAdapter
          )

          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.prepend(
            Extensions::ActiveRecord::ConnectionAdapters::Rails40::PostgreSQLColumn
          )

          ActionView::Helpers::ActiveModelInstanceTag.include(::Apress::Utils::Extensions::ActionView::Helpers::InstanceTag)
        end

        if Utils.rails32?
          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.send(
            :include,
            ::Apress::Utils::Extensions::ActiveRecord::ConnectionAdapters::PostgreSQLColumn
          )
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(
            :include,
            ::Apress::Utils::Extensions::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
          )

          # Original version of pluck in rails 3.2 does not support selection of multiple columns
          ActiveRecord::Relation.send(:include, ::Apress::Utils::Extensions::ActiveRecord::Pluck::Relation)

          ActionView::Helpers::InstanceTag.send(:include, ::Apress::Utils::Extensions::ActionView::Helpers::InstanceTag)
        end

        if Rails::VERSION::MAJOR < 4
          require 'apress/utils/extensions/action_view/helpers/cache_helper'
        end

        if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.2.1')
          ActiveSupport.on_load(:active_record) do
            prepend ::Apress::Utils::Extensions::ActiveRecord::AutosaveAssociation
          end
        end

        require cd + '/extensions/readthis/cache'

        Readthis::Cache.send(:include, ::Apress::Utils::Extensions::Readthis::Cache)
      end

      config.after_initialize do
        ActiveRecord::Base.connection.send(:reload_type_map) if Utils.rails40?
      end
    end
  end
end
