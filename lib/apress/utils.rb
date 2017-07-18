# coding: utf-8
require 'apress/utils/version'

require 'rails-cache-tags'
require 'readthis'
require 'simpleidn'

module Apress
  module Utils
    def rails32?
      Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 2
    end

    def rails40?
      Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0
    end

    def rails41?
      Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 1
    end

    module_function :rails32?, :rails40?, :rails41?
  end
end

require 'apress/utils/engine'
