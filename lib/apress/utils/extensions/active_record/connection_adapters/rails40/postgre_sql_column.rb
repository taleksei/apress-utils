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
                case field_type
                when *::ActiveRecord::Base.connection.enum_types.values
                  field_type.to_sym
                else
                  super(field_type)
                end
              end

              module ClassMethods
                def extract_value_from_default(default)
                  default_value = super
                  return default_value if default_value

                  if match = /\A'(.*)'::(.*)\z/.match(default)
                    if ::ActiveRecord::Base.connection.enum_types.values.include?(match[2])
                      return match[1]
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
