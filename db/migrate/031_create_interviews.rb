class CreateInterviews < ActiveRecord::Migration
  def self.up
    create_table :interviews do |t|
      t.column :scheduled_at, :datetime
      t.column :notes, :text
      t.column :candidate_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :interviews
  end
end
