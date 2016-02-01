ActiveRecord::Schema.define do
  create_table :cached_queries do |t|
    t.string :name
  end

  create_table :people do |t|
    t.string :first_name
    t.string :last_name
  end

  create_table :phrases do |t|
    t.string :text
    t.references :person
  end
end
