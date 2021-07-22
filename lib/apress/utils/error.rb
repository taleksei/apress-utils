# frozen_string_literal: true
module Apress::Utils
  class Error < ::StandardError
    attr_accessor :inner_error

    def to_s
      result = super
      result << " (#{inner_error.to_s})" if inner_error
    end

    def backtrace
      if inner_error
        inner_error.backtrace
      else
        super
      end
    end
  end
end
