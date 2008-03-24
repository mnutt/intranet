class CreatePortraits < ActiveRecord::Migration
  def self.up
    remove_column "users", "portrait"
    create_table :portraits do |t|
      t.column "user_id",  :integer
      t.column "parent_id",  :integer
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      t.column "width", :integer
      t.column "height", :integer
    end
  end

  def self.down
    drop_table :portraits
    add_column "users", "portrait", :string
  end
end

