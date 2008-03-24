class CreateHomeworks < ActiveRecord::Migration
  def self.up
    create_table :homeworks do |t|
      t.column :homework_id, :integer
      t.column :answer_id, :integer
      t.column :solution_id, :integer
      t.column :completed_at, :datetime
      t.column :provided_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :homeworks
  end
end
