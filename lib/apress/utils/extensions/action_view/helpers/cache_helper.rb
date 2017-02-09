# coding: utf-8

# Добавляем поддержку cache_if / cache_unless хелперов из Rails 4
module ActionView
  # = Action View Cache Helper
  module Helpers
    module CacheHelper
      # Cache fragments of a view if +condition+ is true
      #
      #   <%= cache_if admin?, project do %>
      #     <b>All the topics on this project</b>
      #     <%= render project.topics %>
      #   <% end %>
      def cache_if(condition, name = {}, options = nil, &block)
        if condition
          cache(name, options, &block)
        else
          yield
        end

        nil
      end

      # Cache fragments of a view unless +condition+ is true
      #
      #   <%= cache_unless admin?, project do %>
      #     <b>All the topics on this project</b>
      #     <%= render project.topics %>
      #   <% end %>
      def cache_unless(condition, name = {}, options = nil, &block)
        cache_if !condition, name, options, &block
      end
    end
  end
end
