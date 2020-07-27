# coding: utf-8

# Нужно для экранирования ключей в неправильной кодировке
# Тк клиент редиса написанный на руби не может сформировать команду тут -
# https://github.com/redis/redis-rb/blob/fd773587/lib/redis/connection/command_helper.rb#L28
# Такая проблема возникает только при записи, тк в конце команды есть значение(value) в бинарной кодировке(ASCII-8BIT).
# При join кодировка всей строки преобразовавается к кодировке последнего взятого элемента.
# При попытке преобразовать сформированую стороку с ключом в конце(UTF-8*) в кодировку ASCII-8BIT возникает исключение,
# если в ключе есть символы которые несовместимы с ASCII-8BIT
#
# (*ключ всегда в UTF-8, из-за namespace, который задается в application.rb c магическим комментом о кодировке)
#
# Этот хак "обманывает" руби и заставляет его смотреть на стоку в кодировке ASCII-8BIT, позволяя избежать исключения
#
# Можно будет убрать с переходом на руби >= 2.0.0
#
module Apress
  module Utils
    module Extensions
      module Readthis
        module Cache
          extend ActiveSupport::Concern

          included do
            alias_method_chain :write_entity, :encoding
          end

          def write_entity_with_encoding(key, *args)
            key = (key.frozen? ? key.dup : key).force_encoding(Encoding::BINARY)

            write_entity_without_encoding(key, *args)
          end
        end
      end
    end
  end
end
