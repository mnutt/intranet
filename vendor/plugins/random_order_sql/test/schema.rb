ActiveRecord::Schema.define(:version => 0) do
  create_table :random_models, :force => true do |t|
    t.column :name, :string
  end

  create_table :horses, :force => true do |t|
    t.column :random_model_id, :string
  end
end
