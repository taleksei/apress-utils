# coding: utf-8
module Apress::Utils::Extensions::ActionView::Helpers::FormBuilder
  extend ActiveSupport::Concern

  included do
    alias_method_chain :label, :required
  end

  def label_with_required(*args)
    if @options[:auto_required] && object && object.class.validators_on(args.first.to_sym).map(&:class).include?(ActiveModel::Validations::PresenceValidator)
      req_mark = @template.content_tag(:span, "*", :class => "required")
    end
    req_mark ||= ''
    label_without_required(*args) + req_mark
  end

  def error_message_on(method, options = {})
    options = objectify_options(options)
    ::ActionView::Helpers::InstanceTag.new(@object_name, method, self, options.delete(:object)).to_error_message_tag(options)
  end
end