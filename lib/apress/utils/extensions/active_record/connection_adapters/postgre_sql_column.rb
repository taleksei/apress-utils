# coding: utf-8

module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module ConnectionAdapters
          module PostgreSQLColumn
            extend ActiveSupport::Concern

            included do
              def initialize(name, default, sql_type = nil, null = true)
                super(name, self.class.extract_value_from_default(default, sql_type), sql_type, null)
              end

              alias_method_chain :simplified_type, :project_enums

              class << self
                alias_method_chain :extract_value_from_default, :enum
              end
            end

            def simplified_type_with_project_enums(field_type)
              case field_type
              # state types
              when /^(product_label_type|product_state|company_about_state|product_create_user_type|tsvector)$/
                :string
              else
                simplified_type_without_project_enums(field_type)
              end
            end

            module ClassMethods
              # Патч решает проблему с определением дефолтных значений пользовательских enum полей:
              # В текущих версиях рельсов (в плоть до 4.0.2) DEFAULT значения enum полей не учитываются,
              # и при инициализации экземпляра модели акцессор возвращает nil
              #
              # В Rails 4.0.0 появился метод ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.register_type,
              # который частично решает проблему через регистрацию своих типов, где-нибудь в инициализаторе
              def extract_value_from_default_with_enum(default, type = nil)
                return extract_value_from_default_without_enum(default) unless type

                case default
                when /\A'(.*)'::(?:#{Regexp.escape type})\z/
                  $1
                else
                  extract_value_from_default_without_enum default
                end
              end
            end
          end
        end
      end
    end
  end
end
