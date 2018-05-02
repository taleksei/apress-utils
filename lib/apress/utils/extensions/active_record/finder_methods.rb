module Apress::Utils::Extensions::ActiveRecord
  module FinderMethods
    # В рельсах 4.0, в отличии от предыдущих версий, first добавляет сортировку, что
    # крайне негативно сказывается на времени выполнения многих запросов.
    # Возвращаем прежнее поведение, частично откатив изменения реквеста:
    # https://github.com/rails/rails/pull/5153

    def first(limit = nil)
      limit ? limit(limit).to_a : find_first
    end

    def find_first
      if loaded?
        @records.first
      else
        @first ||= limit(1).to_a[0]
      end
    end
  end
end
