class DropAddedByAddAdmin < ActiveRecord::Migration
  def self.up
    remove_column "users", "invited_by"
    add_column "users", "admin", :integer
  end

  def self.down
    add_column "users", "invited_by", :integer
    remove_column "users", "admin"
  end
end
