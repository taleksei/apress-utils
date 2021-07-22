# frozen_string_literal: true

# Public: Модуль, расширяющий наследников ActiveRecord::Base, которые используют механизм STI и
#         хранят в таблице STI класс без неймспейса.
module Apress::Utils::Extensions::ActiveRecord::StorePartialStiClass
  extend ActiveSupport::Concern

  included do
    self.store_full_sti_class = false
  end

  module ClassMethods
    protected

    # Protected: Рассчитывает тип модели, используя текущий неймспейс в качестве префикса.
    #
    # Это патч метода ActiveRecord::Base.compute_type, призванный его ускорить.
    # В отличии от оригинала не пытается найти класс, пробегая по всем уровням
    # вложенности текущего неймспейса.
    # Данный метод ожидает в качестве аргумента либо название класса без неймспейса,
    # либо полное название класса. Обработка полного названия класса необходима,
    # т.к. метод используется в AssociationReflection#klass для нахождения класса ассоциаций.
    #
    # Examples:
    #
    #   Apress::Companies::Menus::CompanyMenus::Base.compute_type('VerticalMenu')
    #   # => Apress::Companies::Menus::CompanyMenus::VerticalMenu
    #
    #   Apress::Companies::Menus::CompanyMenus::Base.compute_type(
    #     'Apress::Companies::Menus::CompanyMenuItems::CustomizedDefaultMenuItem'
    #   )
    #   # => Apress::Companies::Menus::CompanyMenuItems::CustomizedDefaultMenuItem
    #
    #   Apress::Companies::Menus::CompanyMenus::Base.compute_type('::VerticalMenu')
    #   # => VerticalMenu
    def compute_type(type_name)
      if type_name.start_with?('::')
        ActiveSupport::Dependencies.constantize(type_name)
      else
        namespace = name.sub!(/::\w+\z/, '')
        begin
          ActiveSupport::Dependencies.constantize("#{namespace}::#{type_name}")
        rescue NameError => e
          # We don't want to swallow NoMethodError < NameError errors
          raise e unless e.instance_of?(NameError)
          ActiveSupport::Dependencies.constantize(type_name)
        end
      end
    end
  end
end
