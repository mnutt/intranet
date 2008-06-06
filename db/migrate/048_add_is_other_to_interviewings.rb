class AddIsOtherToInterviewings < ActiveRecord::Migration
  def self.up
    add_column :interviewings, :is_other, :boolean  
  end

  def self.down
    remove_column :interviewings, :is_other  
  end
end
