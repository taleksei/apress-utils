# coding: utf-8
module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module MigrationProxy
          extend ActiveSupport::Concern

          included do
            alias_method_chain :migration, :proxy
          end

          private

          def migration_with_proxy
            migration_without_proxy

            @migration.proxy = self
            @migration
          end
        end
      end
    end
  end
end