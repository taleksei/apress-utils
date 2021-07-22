# frozen_string_literal: true
# Загружает роуты плагина (пока простым вызовом), на место вызова не влияют скоупы и прочая нечисть
#
# == Примеры использования
#
#   1. Подключение всех роутов плагина (админка, проект)
#      use_plugin_routes :core_plugin
#
#   2. Подключение всех роутов плагина (админка, проект)
#      use_plugin_routes :core_plugin => [:app, :admin]
#
#   3. Подключение только роутов проекта (frontend)
#      use_plugin_routes :core_plugin => :app
#
#   4. Подключение только роутов админки (backend)
#      use_plugin_routes :core_plugin => :admin
#
#  TODO: ActionDispatch::Routing::Mapper

module Apress::Utils::Extensions::ActionDispatch
  module RoutesLoader

    private
    def use_plugin_routes(*args)
      plugins_with_options = args.extract_options!.symbolize_keys
      plugins     = (args || []).map(&:to_sym)
      path_sample = "#{Rails.root}/vendor/plugins/%{plugin}/config/%{plugin}%{type}_routes.rb"
      load_routes = {}

      # TODO Можно оптимизировать, но лень
      plugins_with_options.each {|plugin, options| load_routes[plugin] = cast_option_type(options) }
      plugins.each { |plugin| load_routes[plugin] = cast_option_type :all }

      load_routes.each do |plugin, options|
        options.each do |type|
          filename = path_sample % {:plugin => plugin, :type => type_postfix(type)}
          load filename if File.exist? filename
        end
      end
    end

    def cast_option_type(options)
      options = [options].flatten.map(&:to_sym)

      return [] if options.blank?
      return [:app, :admin] if options.include?(:all)

      options
    end

    def type_postfix(option)
      return '' if option.blank? || option.to_sym == :app

      '_admin'
    end
  end
end
