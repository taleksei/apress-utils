# -*- encoding : utf-8 -*-
module Apress::Utils::Extensions::ActiveRecord
  module ValidateUniquenessInMemory

    def self.included(model)
      model.send(:include, ValidateMethods)
    end

  end

  module ValidateMethods
    def self.included(model)
      model.class_eval do
        # Validate that the the objects in +collection+ are unique
        # when compared against all their non-blank +attrs+. If not
        # add +message+ to the base errors.
        def validate_uniqueness_of_in_memory(collection, attrs, message, attribute = :base)
          hashes = collection.inject({}) do |hash, record|
            key = attrs.map {|a| record.send(a).to_s }.join
            if key.blank? || record.marked_for_destruction?
              key = record.object_id
            end
            hash[key] = record unless hash[key]
            hash
          end
          if collection.length > hashes.length
            self.errors.add(attribute, message)
          end
        end
      end
    end
  end

end