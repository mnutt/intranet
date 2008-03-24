class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table :doctors do |t|
      t.column :name, :string
      t.column :in_network, :boolean
      t.column :address, :string
      t.column :copay, :integer
      t.column :comments, :text
      t.column :specialty, :string
    end
  end

  def self.down
    drop_table :doctors
  end
end
