class AddEmailToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :email, :string  
  end

  def self.down
    remove_column :candidates, :email  
  end
end
