class RemoveJobDescriptionFromUser < ActiveRecord::Migration
  def self.up
    remove_column "users", "job_description"
  end

  def self.down
  end
end
