# -*- encoding : utf-8 -*-
module ActionController

  class Metal
    attr_internal :cached_content_for
  end

  module Caching
    module Actions
      def _save_fragment(name, options)
        return unless caching_allowed?

        content = response_body
        content = content.join if content.is_a?(Array)
        content = cached_content_for.merge(:layout => content) if cached_content_for.is_a?(Hash)

        write_fragment(name, content, options)
      end
    end

    module Fragments
      def write_fragment_with_content_to_cache(key, content, options = nil)
        return content unless cache_configured?

        key = fragment_cache_key(key)
        instrument_fragment_cache :write_fragment, key do
          cache_store.write(key, content, options)
        end

        content.is_a?(Hash) ? content[:layout] : content
      end

      def read_fragment_with_content_to_cache(key, options = nil)
        result = read_fragment_without_content_to_cache(key, options)
        if result.is_a?(Hash) && result.key?(:layout)
          self.cached_content_for = result.except(:layout)
          result = result[:layout]
        end

        result.respond_to?(:html_safe) ? result.html_safe : result
      end

      alias_method_chain :write_fragment, :content_to_cache
      alias_method_chain :read_fragment, :content_to_cache
    end
  end
end

module ActionView
  class TemplateRenderer < AbstractRenderer
    # Added to support implementation of action caching
    def render_template_with_cached_content_for(template, layout_name = nil, locals = {})
      controller = @view.controller
      if controller.respond_to?('caching_allowed?') &&
         controller.caching_allowed? &&
         defined?(ApplicationController) && controller.is_a?(ApplicationController)

        controller.cached_content_for.each { |k, v| @view.content_for(k, v) unless @view.content_for?(k) } if controller.cached_content_for.is_a?(Hash)
        return_value = render_template_without_cached_content_for(template, layout_name, locals)
        controller.cached_content_for = @view.content_to_cache
      elsif
        return_value = render_template_without_cached_content_for(template, layout_name, locals)
      end

      return_value
    end

    alias_method_chain :render_template, :cached_content_for
  end

  module Helpers
    module CaptureHelper
      # Added to support implementation of fragment caching
      def cache_with_content_for #:nodoc:#
        @_subset_content_for ||= []
        @_subset_content_for.push(Hash.new { |h,k| h[k] = ActiveSupport::SafeBuffer.new })
        @cache_level = @_subset_content_for.size

        yield
      ensure
        @_subset_content_for.pop
        @cache_level = @_subset_content_for.size
      end

      def cache_level
        @cache_level ||= 1
        @cache_level - 1
      end

      # Added to support implementation of action caching
      def content_to_cache #:nodoc:#
        cache_this = (@_subset_content_for && @_subset_content_for[cache_level]) || @view_flow.content.except(:layout)
        cache_this.dup.tap {|h| h.default = nil }
      end

      # Overwrite content_for to support fragment caching
      def content_for(name, content = nil, &block)
        content = capture(&block) if block_given?
        if content
          if @_subset_content_for && @_subset_content_for[cache_level]
            @_subset_content_for[cache_level][name] << content

            # также нужно передать этот контент всем родительским кеш-блокам
            (cache_level - 1).downto(0) do |i|
              @_subset_content_for[i][name] << content
            end
          end
          @view_flow.append(name, content)
          nil
        else
          @view_flow.get(name)
        end
      end
    end

    module CacheHelper
      def fragment_for(name = {}, options = nil, &block) #:nodoc:
        if (fragment = controller.read_fragment(name, options))
          controller.cached_content_for.each { |k, v| content_for(k, v) } if controller.cached_content_for.is_a?(Hash)
          fragment
        else
          pos = output_buffer.length
          hash_to_cache = nil
          cache_with_content_for do
            yield

            output_safe = output_buffer.html_safe?
            fragment = output_buffer.slice!(pos..-1)
            if output_safe
              self.output_buffer = output_buffer.class.new(output_buffer)
            end

            hash_to_cache = {:layout => fragment}.merge(content_to_cache)
          end

          controller.write_fragment(name, hash_to_cache, options)
        end
      end
    end
  end
end
