ActiveRecord::Schema.define do
  create_table :cached_queries do |t|
    t.string :name
  end
end
