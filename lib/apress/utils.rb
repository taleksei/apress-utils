require 'apress/utils/version'

require 'rails-cache-tags'
require 'readthis'
require 'simpleidn'

module Apress
  module Utils
    def rails40?
      Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 0
    end

    def rails41?
      Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 1
    end

    def rails42?
      Rails::VERSION::MAJOR == 4 && Rails::VERSION::MINOR == 2
    end

    module_function :rails40?, :rails41?, :rails42?
  end
end

require 'apress/utils/engine'
