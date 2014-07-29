# coding: utf-8
module Apress
  module Utils
    module Extensions
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

        module InstanceMethods
          def simplified_type_with_project_enums(field_type)
            case field_type
              # state types
              when /^(product_state|company_about_state|product_create_user_type|tsvector)$/
                  :string
              else
                simplified_type_without_project_enums(field_type)
            end
          end
        end

        module ClassMethods
          # Патч решает проблему с определением дефолтных значений пользовательских enum полей:
          # В текущих версиях рельсов (в плоть до 4.0.2) DEFAULT значения enum полей не учитываются, и при инициализации
          # экземпляра модели акцессор возвращает nil
          #
          # В Rails 4.0.0 появился метод ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::OID.register_type, который
          # частично решает проблему через регистрацию своих типов, где-нибудь в инициализаторе
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

      module PostgreSQLAdapter
        extend ActiveSupport::Concern

        included do
          def add_column(table_name, column_name, type, options = {})
            add_column_sql = "ALTER TABLE #{quote_table_name(table_name)} ADD COLUMN #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}"
            add_column_options!(add_column_sql, options)

            begin
              execute add_column_sql
            rescue ActiveRecord::StatementInvalid => e
              raise e if postgresql_version > 80000

              execute("ALTER TABLE #{quote_table_name(table_name)} ADD COLUMN #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale])}")
              change_column_default(table_name, column_name, options[:default]) if options_include_default?(options)
              change_column_null(table_name, column_name, options[:null], options[:default]) if options.key?(:null)
            end
          end

          # WARNING : Жестоко отключаются prepared_statements для постгреса
          #           Все измениния в коде идентичны rails 3.1.12
          #
          # Cуть: Адаптер не смотрит на настройки, а ориентируется по наличию в аргументах - биндингов
          #       Убрали биндинги – не стало кжширования запроса
          # Оригинал: https://github.com/rails/rails/pull/5872#commitcomment-1380174
          def table_exists?(name)
            schema, table = extract_schema_and_table(name.to_s)
            return false unless table

            table = table.gsub(/(^"|"$)/,'')

            exec_query(<<-SQL, 'SCHEMA').rows.any?
              SELECT 1
              FROM pg_tables
              WHERE tablename = #{quote(table)}
              AND schemaname = #{schema ? quote(schema) : "ANY (current_schemas(false))"}
              LIMIT 1
            SQL
          end

          def schema_exists?(name)
            exec_query(<<-SQL, 'SCHEMA').rows.any?
              SELECT 1
              FROM pg_namespace
              WHERE nspname = #{quote(name)}
              LIMIT 1
            SQL
          end

          def primary_key(table)
            row = exec_query(<<-SQL, 'SCHEMA').rows.first
              SELECT DISTINCT(attr.attname)
              FROM pg_attribute attr
              INNER JOIN pg_depend dep ON attr.attrelid = dep.refobjid AND attr.attnum = dep.refobjsubid
              INNER JOIN pg_constraint cons ON attr.attrelid = cons.conrelid AND attr.attnum = cons.conkey[1]
              WHERE cons.contype = 'p'
                AND dep.refobjid = '#{quote_table_name(table)}'::regclass
            SQL

            row && row.first
          end

          def serial_sequence(table, column)
            result = exec_query(<<-SQL, 'SCHEMA')
              SELECT pg_get_serial_sequence(#{quote(table)}, #{quote(column)})
            SQL
            result.rows.first.first
          end

          def last_insert_id(sequence_name)
            r = exec_query("SELECT currval(#{quote(sequence_name)})", 'SQL')
            Integer(r.rows.first.first)
          end
        end
      end

      module AbstractAdapter
        extend ActiveSupport::Concern

        included do
          def log(sql, name = "SQL", binds = [])
            @instrumenter.instrument(
              "sql.active_record",
              :sql => sql,
              :name => name,
              :connection_id => object_id,
              :binds => binds) { yield }
          rescue Exception => e
            message = "#{e.class.name}: #{e.message.force_encoding('UTF-8')}: #{sql.force_encoding('UTF-8')}"
            @logger.debug message if @logger
            exception = translate_exception(e, message)
            exception.set_backtrace e.backtrace
            raise exception
          end
        end
      end

      module ConnectionPool
        extend ActiveSupport::Concern

        included do
          # Исправленная или оптимизированная версия метода.
          # В оригинальном методе из AR 3.1, для таблиц, которые не существуют в БД,
          # результат не кешируется и каждый раз происходит запрос всех таблиц БД.
          # FIXME: избавиться при переходе на Rails 3.2
          def table_exists?(name)
            return @tables[name] if @tables.key? name

            connection.tables.each { |table| @tables[table] = true }
            @tables[name] = connection.table_exists?(name) unless @tables.key?(name)

            @tables[name]
          end
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLColumn.send :include, Apress::Utils::Extensions::PostgreSQLColumn
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, Apress::Utils::Extensions::PostgreSQLAdapter
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Apress::Utils::Extensions::AbstractAdapter
ActiveRecord::ConnectionAdapters::ConnectionPool.send :include, Apress::Utils::Extensions::ConnectionPool