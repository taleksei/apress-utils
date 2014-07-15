# coding: utf-8
require 'rails'
require 'action_dispatch/routing/mapper'

module Apress
  module Utils
    class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/"]

      config.after_initialize do
        ::ActionDispatch::Routing::Mapper.send :include, ::Apress::Utils::Extensions::ActionDispatch::Routing::Mapper
      end
    end
  end
end