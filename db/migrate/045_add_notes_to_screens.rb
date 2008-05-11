class AddNotesToScreens < ActiveRecord::Migration
  def self.up
    add_column :screens, :notes, :text  
  end

  def self.down
    remove_column :screens, :notes  
  end
end
