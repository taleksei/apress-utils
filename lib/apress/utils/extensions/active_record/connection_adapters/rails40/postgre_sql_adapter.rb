# frozen_string_literal: true
module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module ConnectionAdapters
          module Rails40
            module PostgreSQLAdapter
              def self.prepended(base)
                base::OID.include(OIDEnum)
              end

              module OIDEnum
                class Enum < ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID::Type
                  def type_cast(value)
                    value.to_s unless value.nil?
                  end
                end
              end

              def enum_types
                result = execute "SELECT DISTINCT oid, typname FROM pg_type where typcategory = 'E'", 'SCHEMA'
                result.to_a.each_with_object({}) { |row, h| h[row['oid'].to_i] = row['typname'] }
              end

              def initialize_type_map
                super

                enum_types.reject { |_, name| self.class::OID.registered_type?(name) }.each do |oid, name|
                  self.class::OID::TYPE_MAP[oid] = self.class::OID::Enum.new
                end
              end
            end
          end
        end
      end
    end
  end
end
