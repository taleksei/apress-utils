module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module ConnectionAdapters
          module Rails40
            module PostgreSQLColumn
              def self.prepended(base)
                base.singleton_class.prepend(ClassMethods)
              end

              def simplified_type(field_type)
                type = super(field_type)

                return type if type

                if ::ActiveRecord::Base.connection.enum_types.values.include?(field_type)
                  field_type.to_sym
                end
              end

              module ClassMethods
                def extract_value_from_default(default)
                  default_value = super
                  return default_value unless default_value.nil?

                  if match = /\A'(.*)'::(.*)\z/.match(default)
                    if ::ActiveRecord::Base.connection.enum_types.values.include?(match[2])
                      match[1]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
