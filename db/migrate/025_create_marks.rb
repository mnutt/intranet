class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.column :user_id, :integer
      t.column :photo_id, :integer
      t.column :x_coord, :float
      t.column :y_coord, :float
    end
  end

  def self.down
    drop_table :marks
  end
end
