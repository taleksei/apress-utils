ActiveRecord::Schema.define do
  create_table :cached_queries do |t|
    t.string :name
  end

  execute "create type people_state as enum ('pending', 'active')"

  create_table :people do |t|
    t.string :first_name
    t.string :last_name
    t.column :state, 'people_state', default: 'pending'
  end

  create_table :phrases do |t|
    t.string :text
    t.references :person
  end

  create_table :test_models do |t|
    t.string :name
  end
end
