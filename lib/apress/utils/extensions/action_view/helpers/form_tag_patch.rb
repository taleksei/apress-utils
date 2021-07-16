# frozen_string_literal: true
module ActionView
  module Helpers
    module FormTagHelper
      def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
        wait_text = options[:wait_text].present? ? options[:wait_text] : nil
        disable_period = options[:submit_disable_period].present? ? options.delete(:submit_disable_period) : nil
        options[:onsubmit] = %{formSubmitter.disableButtons(this, #{wait_text.to_json}, #{disable_period.to_json});#{options[:onsubmit].present? ? options[:onsubmit] : ''}}

        html_options = html_options_for_form(url_for_options, options, *parameters_for_url)
        html_options["accept-encoding"] = "UTF-8" # TODO Rails - убрать

        if block_given?
          if ::Rails::VERSION::MAJOR == 4 && ::Rails::VERSION::MINOR < 2
            # https://apidock.com/rails/v4.1.8/ActionView/Helpers/FormTagHelper/form_tag_in_block
            form_tag_in_block(html_options, &block)
          else
            # https://apidock.com/rails/v4.2.1/ActionView/Helpers/FormTagHelper/form_tag_with_body
            form_tag_with_body(html_options, capture(&block))
          end
        else
          form_tag_html(html_options)
        end
      end
    end
  end
end
