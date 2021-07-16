# frozen_string_literal: true
class Phrase < ActiveRecord::Base
  belongs_to :person
end
