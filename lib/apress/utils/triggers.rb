# coding: utf-8
module Apress::Utils
  class Triggers
    class << self
      def disable_triggers(options)
        triggers(options).map(&:disable)
        nil
      end

      def enable_triggers(options)
        triggers(options).map(&:enable)
        nil
      end

      def drop_triggers(options)
        triggers(options).map(&:drop)
        nil
      end

      def exists?(options)
        triggers(options).present?
      end

      def triggers(options = {})
        default_options = {
            :trigger_pattern => '',
            :table_pattern => '',
            :connection => default_connection
        }

        options.reverse_merge!(default_options)

        build_triggers(options[:connection].execute(<<-SQL))
          SELECT
            n.nspname || '.' || c.relname AS relname,
            t.tgname
          FROM pg_trigger t
          INNER JOIN pg_class c ON c.oid = t.tgrelid
          INNER JOIN pg_namespace n ON n.oid = c.relnamespace
          WHERE t.tgname ~ '#{options[:trigger_pattern]}'
            AND n.nspname || '.' || c.relname ~ '#{options[:table_pattern]}'
        SQL
      end

      protected

      def build_triggers(enumerator)
        enumerator.map{|row| Trigger.new(row['relname'], row['tgname'])}
      end

      def default_connection
        ActiveRecord::Base.connection
      end

    end

    class Trigger
      delegate :connection, :to => ActiveRecord::Base
      attr_reader :relname, :name

      def initialize(relname, name)
        @relname = relname
        @name    = name
      end

      def quoted_name
        connection.quote_table_name(name)
      end

      def quoted_relname
        connection.quote_table_name(relname)
      end

      def disable
        connection.execute "ALTER TABLE #{quoted_relname} DISABLE TRIGGER #{quoted_name}"
        nil
      end

      def enable
        connection.execute "ALTER TABLE #{quoted_relname} ENABLE TRIGGER #{quoted_name}"
        nil
      end

      def drop
        connection.execute "DROP TRIGGER #{quoted_name} ON #{quoted_relname}"
        nil
      end
    end
  end
end