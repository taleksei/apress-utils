# frozen_string_literal: true
module Apress::Utils::Extensions::ActiveRecord
  module TransactionDetection

    def self.included(base) #:nodoc:
      base.send(:extend,  Methods)
      base.send(:include, Methods)
    end

    def self.extended(base) #:nodoc:
      base.send(:extend,  Methods)
      base.send(:include, Methods)
    end

    module Methods
      def in_transaction?
        false === connection.outside_transaction?
      end
    end

  end
end
