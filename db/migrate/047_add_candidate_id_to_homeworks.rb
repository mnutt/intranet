class AddCandidateIdToHomeworks < ActiveRecord::Migration
  def self.up
    add_column :homeworks, :candidate_id, :integer  
  end

  def self.down
    remove_column :homeworks, :candidate_id  
  end
end
