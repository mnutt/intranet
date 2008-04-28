class CreateInterviewings < ActiveRecord::Migration
  def self.up
    create_table :interviewings do |t|
      t.integer :interview_id
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.text :topics
      t.text :notes
      t.string :verdict
      t.string :verdict_explanation

      t.timestamps 
    end
  end

  def self.down
    drop_table :interviewings
  end
end
