class AddFormerStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :former, :boolean, :default => false
  end

  def self.down
    remove_column :users, :former
  end
end
