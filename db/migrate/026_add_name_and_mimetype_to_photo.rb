class AddNameAndMimetypeToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, 'name', :string
    add_column :photos, 'mimetype', :string
  end

  def self.down
  end
end
