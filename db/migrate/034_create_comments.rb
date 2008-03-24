class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :commenter_id, :integer
      t.column :content, :text
      t.column :commentable_id, :integer
      t.column :commentable_type, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
