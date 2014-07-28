# coding: utf-8
module Apress::Utils
  class Tables
    class << self
      # Public: Выбирает таблицы, согласно заданныи опциям.
      #
      # options - хеш опций:
      #           schema_pattern - String - PostgreSQL regexp pattern имени схемы.
      #                            По умолчанию: выбираются все схемы.
      #           table_pattern  - String - PostgreSQL regexp pattern имени таблицы.
      #                            По умолчанию: выбираются все таблицы.
      #           limit          - Fixnum - лимит на выборку.
      #                            По умолчанию: нет.
      #                            По умолчанию: основное соединение приложения.
      #           connection     - ActiveRecord::Connection - конект к БД.
      #                            По умолчанию: основное соединение приложения.
      #
      # Returns Array of Table.
      #
      def select(options)
        options.reverse_merge!(default_options)
        connection = options.fetch(:connection)

        build_tables(connection.execute(<<-SQL), connection)
          SELECT schemaname as schema, tablename as table
            FROM pg_tables
          WHERE schemaname ~ '#{options.fetch(:schema_pattern)}'
            AND tablename ~ '#{options.fetch(:table_pattern)}'
          ORDER BY schemaname, tablename
          #{options.key?(:limit) ? "LIMIT #{options[:limit]}" : ''}
        SQL
      end

      def exists?(options)
        select(options.merge(:limit => 1)).present?
      end

      def default_options
        {
          :connection => ActiveRecord::Base.connection,
          :schema_pattern => '',
          :table_pattern => ''
        }
      end

      protected

      def build_tables(enumerator, connection)
        enumerator.map { |row| Table.new(row.merge!(:connection => connection)) }
      end
    end

    class Table
      attr_reader :schema, :name, :connection

      def initialize(options)
        options.symbolize_keys!
        options.reverse_merge!(self.class.default_options)

        @connection = options.fetch(:connection)
        @schema = options.fetch(:schema)
        @name   = options.fetch(:table)
      end

      def full_name
        "#{schema}.#{name}"
      end

      def quoted_name
        connection.quote_table_name(name)
      end

      def quoted_full_name
        connection.quote_table_name(full_name)
      end

      def self.default_options
        {
          :connection => ActiveRecord::Base.connection,
          :schema => 'public'
        }
      end
    end
  end
end