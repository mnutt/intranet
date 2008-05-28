class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.integer :user_id
      t.integer :remindable_id
      t.datetime :remind_time
      t.string :remindable_type
      t.text :message
      t.string :transport

      t.timestamps 
    end
  end

  def self.down
    drop_table :reminders
  end
end
