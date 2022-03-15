# frozen_string_literal: true

module ActionView
  module Helpers
    module FormHelper
      def html_options_for_form(url_for_options, options)
        if ::Rails::VERSION::MAJOR >= 4.2
          wait_text = options[:wait_text].present? ? options[:wait_text] : nil
          disable_period = options[:submit_disable_period].present? ? options.delete(:submit_disable_period) : nil
          options[:onsubmit] = %{formSubmitter.disableButtons(this, #{wait_text.to_json}, #{disable_period.to_json});#{options[:onsubmit].present? ? options[:onsubmit] : ''}}
        end
        options = super(url_for_options, options)
      end
    end
  end
end
