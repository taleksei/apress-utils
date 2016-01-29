module Apress::Utils::Extensions::ActiveRecord::Pluck
  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      delegate :pluck, to: :scoped
    end
  end

  module Associations
    module CollectionProxy
      extend ActiveSupport::Concern

      included do
        delegate :pluck, to: :scoped
      end
    end
  end

  # = Active Record Relation
  module Relation
    # Returns <tt>Array</tt> with values of the specified column name
    # or <tt>Array</tt> of <tt>Array</tt>'s for multiple columns.
    # The values has same data type as column.
    #
    # Examples:
    #
    # Person.pluck(:id) # SELECT people.id FROM people
    # Person.uniq.pluck(:role) # SELECT DISTINCT role FROM people
    # Person.where(:confirmed => true).limit(5).pluck(:id)
    # Person.order(:name).pluck(:name, :age)
    #
    def pluck(*column_names)
      column_names.map! do |column_name|
        if column_name.is_a?(Symbol) && column_names.include?(column_name.to_s)
          "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(column_name)}"
        else
          column_name.to_s
        end
      end

      relation = clone
      relation.select_values = column_names
      klass.connection.select_all(relation.arel).map! do |attributes|
        result = attributes.map do |column, attribute|
          type_cast_using_column(attribute, column_for(column))
        end
        result.one? ? result.first : result
      end
    end
  end
end
