# coding: utf-8
module Apress::Utils::Extensions::ActionView::Helpers::InstanceTag

  def to_error_message_tag(options)
    return unless object
    errors = []
    object.errors.each{ |attr, err| errors.push(err) if attr.to_s == @method_name.to_s}
    return if errors.empty?

    options[:class] ||= 'form-error'
    # пока показываем тольк первую ошибку, возможно нужно показывать все?
    content_tag(:span, "#{errors.first}".html_safe, options)
  end

end