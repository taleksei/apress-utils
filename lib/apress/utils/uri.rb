# -*- encoding : utf-8 -*-
require 'addressable/uri'

module Apress::Utils
  module Uri

    # Исключение для encode_punycode
    class EncodeRusError < StandardError
    end

    def cyrillic? str
      str =~ /[а-яА-ЯёЁ]/
    end


    # Возвращает урл приведенный к "нормальному" виду.
    # 1. Если название сайта на кирилице, то преобразует его
    # 2. Делает URI::encode для пути из урл
    #
    # Оно используется в плагине Core_yml.
    # Используйте его только если хорошо понимаете как оно работает и что это подходит под ваши задачи
    #
    # @see String.to_punycode
    #
    # @deprecated - нахер он не нужен.
    # @param url[String] - урл
    # @raise [Apress::Utils::Uri::EncodeRusError] - мы принимаем урл только в формате (http|ftp|https)://<site>(......) иначе выбрасывает исключение
    # @raise [IDN::Idna::IdnaError] - другие ошибки @see IDN::Idna::IdnaError
    def encode_punycode(url)
      # если url не правильного формата выкидываем исключение
      raise(EncodeRusError, "не правильный формат входящего урл. должно быть (http|ftp|https)://<site>(......)") unless /^(http|ftp|https):\/\//.match(url)

      Addressable::URI.parse(url).normalize.to_s
    end
  end
end