class RemoveTags < ActiveRecord::Migration
  def self.up
    drop_table :tags
  end

  def self.down
  end
end
