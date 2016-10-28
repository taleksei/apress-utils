# coding: utf-8

module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module ConnectionAdapters
          module PostgreSQLAdapter
            extend ActiveSupport::Concern

            included do
              private

              # HACK: предотвращает использование prepared statements для postgres-адаптера в rails 3.2.
              # Если в PG::Connection#async_exec передавать в binds пустой массив в текущей версии pg
              # на наших проектах (0.16.0-0.18.4), то будет задействован механизм подготовленных выражений. Запросы,
              # в которых несколько инструкций, начинают падать с ошибкой
              # PG::SyntaxError: ERROR:  cannot insert multiple commands into a prepared statement
              #
              # Оригинал метода:
              # https://github.com/rails/rails/blob/3-2-stable/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L1162
              # https://github.com/rails/rails/blob/3-2-stable/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L660
              #
              # Переписан по аналогии с 3.1:
              # https://github.com/rails/rails/blob/3-1-stable/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L1060
              def exec_no_cache(sql, _binds)
                @connection.async_exec(sql)
              end
            end
          end
        end
      end
    end
  end
end
