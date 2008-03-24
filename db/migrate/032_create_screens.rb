class CreateScreens < ActiveRecord::Migration
  def self.up
    create_table :screens do |t|
      t.column :screener_id, :integer
      t.column :scheduled_at, :datetime
      t.column :candidate_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :screens
  end
end
