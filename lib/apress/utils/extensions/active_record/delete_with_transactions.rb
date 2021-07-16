# -*- encoding : utf-8 -*-
# frozen_string_literal: true
module Apress::Utils::Extensions::ActiveRecord
  module DeleteWithTransactions

    def self.included(base) #:nodoc:
      base.alias_method_chain :delete, :transactions
    end

    def delete_with_transactions(*args, &block) #:nodoc:
      with_transaction_returning_status(:delete_without_transactions, *args, &block)
    end

  end
end
