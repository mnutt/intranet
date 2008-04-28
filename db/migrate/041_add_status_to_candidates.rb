class AddStatusToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :status, :string
  end

  def self.down
    remove_column :candidates, :status
  end
end
