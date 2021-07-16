# frozen_string_literal: true
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
        require cd + '/extensions/content_for_cache'
        require cd + '/extensions/action_view/helpers/form_tag_patch'

        if Rails.version < '5'
          ActionView::Helpers::FormBuilder.include(::Apress::Utils::Extensions::ActionView::Helpers::FormBuilder)
        end

        if Utils.rails40?
          ActionDispatch::Routing::Mapper.include(::Apress::Utils::Extensions::ActionDispatch::RoutesLoader)

          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(
            Apress::Utils::Extensions::ActiveRecord::ConnectionAdapters::Rails40::PostgreSQLAdapter
          )

          ActiveRecord::ConnectionAdapters::PostgreSQLColumn.prepend(
            Extensions::ActiveRecord::ConnectionAdapters::Rails40::PostgreSQLColumn
          )
        end

        if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.2.1')
          ActiveSupport.on_load(:active_record) do
            prepend ::Apress::Utils::Extensions::ActiveRecord::AutosaveAssociation
          end
        end

        require cd + '/extensions/readthis/cache'

        Readthis::Cache.send(:include, ::Apress::Utils::Extensions::Readthis::Cache)

        if Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR < 2
          require 'apress/utils/extensions/action_dispatch/flash'
        end

        if Rails::VERSION::MAJOR == 4
          ActiveRecord::Relation.prepend(Extensions::ActiveRecord::FinderMethods)

          if Rails::VERSION::MINOR < 1
            require 'apress/utils/extensions/active_support/time_with_zone'
          end
        end
      end
    end
  end
end
