class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :taken_at, :datetime
      t.column :description, :text
    end
  end

  def self.down
    drop_table :photos
  end
end
