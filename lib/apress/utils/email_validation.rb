# coding: utf-8

# Public: Содержит регулярное выражение необходимое для валидации email.
module Apress
  module Utils
    module EmailValidation
      EMAIL_REGEXP = /\A[a-z0-9\-_]+(?:\.[a-z0-9\-\._]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z]{2,}\Z/i

      def regexp
        EMAIL_REGEXP
      end
      module_function :regexp
    end
  end
end
