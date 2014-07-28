# -*- encoding : utf-8 -*-
module Apress::Utils::Extensions::ActiveRecord
  module TransactionIsolation

    def self.included(base) #:nodoc:
      base.send(:include, Apress::Utils::Extensions::ActiveRecord::TransactionDetection)
      base.send(:extend,  Isolation)
      base.send(:include, Isolation)
    end

    def self.extended(base) #:nodoc:
      base.send(:include, Apress::Utils::Extensions::ActiveRecord::TransactionDetection)
      base.send(:extend,  Isolation)
      base.send(:include, Isolation)
    end

    module Isolation
      def isolation(level)
        raise "Invalid transaction isolation level [#{level.inspect}]" unless [
          :serializable, :repeatable_read, :read_committed, :read_uncommitted
        ].include?(level)

        isolation_query = "SET TRANSACTION ISOLATION LEVEL #{level.to_s.upcase.gsub(/_/, ' ')}"

        if in_transaction?
          connection.execute(isolation_query)
          yield if block_given?

        elsif block_given?
          transaction do
            connection.execute(isolation_query)
            yield
          end

        else
          raise %q(Can't change isolation level outside transaction)
        end
      end
    end

  end
end
