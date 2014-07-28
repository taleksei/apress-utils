# coding: utf-8
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
          form_tag_in_block(html_options, &block)
        else
          form_tag_html(html_options)
        end
      end
    end
  end
end

# Кэширование проверки существования таблицы
#
# WARNING : Сткрытые фишечки
# Данный monkey-patch чинит проблему с кэшированием prepared_statements для PostgreSQL в рельсах 3.1
#
# Одним из вариантов было отключение передачи биндингов в запросы
# https://github.com/rails/rails/pull/5872#commitcomment-1380174
# но т.к тут есть кэширование первого запроса, то остальные уже берутся из кэша
ActiveRecord::Base.class_eval do
  class << self
    def table_exists?
      connection_pool.table_exists?(table_name)
    end
  end
end