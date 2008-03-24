class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.column "title", :string
      t.column "description", :text
    end
  end

  def self.down
    drop_table :positions
  end
end
