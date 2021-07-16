# -*- encoding : utf-8 -*-
# frozen_string_literal: true
module Apress::Utils::Extensions::ActiveRecord
  module Lock

    def self.included(base) #:nodoc:
      base.send(:include, Apress::Utils::Extensions::ActiveRecord::TransactionDetection)
      base.send(:extend,  LockMethods)
      base.send(:include, LockMethods)
    end

    def self.extended(base) #:nodoc:
      base.send(:include, Apress::Utils::Extensions::ActiveRecord::TransactionDetection)
      base.send(:extend,  LockMethods)
      base.send(:include, LockMethods)
    end

    module LockMethods
      def lock(*args) #:nodoc:
        options  = args.extract_options!
        mode     = args.first || options[:mode] || :share
        nowait   = options[:nowait] || false

        tables   = options[:tables]
        tables ||= quoted_table_name            if respond_to?(:quoted_table_name)
        tables ||= self.class.quoted_table_name if self.class.respond_to?(:quoted_table_name)
        tables   = [tables].flatten.compact

        lock_query  = "LOCK TABLE #{tables.join(', ')}"
        lock_query << " IN #{mode} MODE" if mode.is_a?(String) || mode.is_a?(Symbol)
        lock_query << " NOWAIT" if nowait

        if in_transaction?
          connection.execute(lock_query)
          yield if block_given?

        elsif block_given?
          transaction do
            connection.execute(lock_query)
            yield
          end

        else
          raise %q(Can't lock tables outside transaction)
        end
      end
    end

  end
end
