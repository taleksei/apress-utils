# coding: utf-8
module Apress
  module Utils
    module Extensions
      module ActiveRecord
        module Migration
          extend ActiveSupport::Concern

          included do
            cattr_accessor :proxy
          end
        end
      end
    end
  end
end