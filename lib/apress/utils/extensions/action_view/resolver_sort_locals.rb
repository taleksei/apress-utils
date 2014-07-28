# coding: utf-8
module Apress::Utils::Extensions::ActionView
  module ResolverSortLocals
    extend ActiveSupport::Concern

    included do
      # TODO : Удалить в версиях выше 3.2.х
      # @tenderlove approved
      # https://github.com/rails/rails/commit/14a8fd146a64f7ed8399339fa5bc0200b54838ea
      private
      def sort_locals(locals) #:nodoc:
        locals.map { |x| x.to_s }.sort!
      end
    end
  end
end