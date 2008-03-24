class SwapUserPortraitAssociations < ActiveRecord::Migration
  def self.up
    remove_column "portraits", "user_id"
    add_column "users", "portrait_id", :integer
  end

  def self.down
    add_column "portraits", "user_id", :integer
    remove_column "users", "portrait_id"
  end
end
