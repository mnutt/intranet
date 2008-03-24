class InvitedBy < ActiveRecord::Migration
  def self.up
    add_column "users", "invited_by", :integer
  end

  def self.down
    remove_column "users", "invited_by"
  end
end
