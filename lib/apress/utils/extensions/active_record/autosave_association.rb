# frozen_string_literal: true
# Fixes 'https://github.com/rails/rails/pull/16640'
require 'active_record/autosave_association'

module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module AutosaveAssociation
          def nested_records_changed_for_autosave?
            @_nested_records_changed_for_autosave_already_called ||= false
            return false if @_nested_records_changed_for_autosave_already_called
            begin
              @_nested_records_changed_for_autosave_already_called = true
              super
            ensure
              @_nested_records_changed_for_autosave_already_called = false
            end
          end
        end
      end
    end
  end
end
