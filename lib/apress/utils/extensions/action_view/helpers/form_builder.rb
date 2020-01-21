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
    object = options[:object]
    return unless object

    instance_tag = ActionView::Helpers::Tags::Base.new(@object_name, method, self, options)

    errors = []
    object.errors.each { |attr, err| errors.push(err) if attr.to_s == method.to_s }
    return if errors.empty?

    options[:class] ||= 'form-error'
    # пока показываем тольк первую ошибку, возможно нужно показывать все?
    instance_tag.content_tag(:span, "#{errors.first}".html_safe, options)
  end
end