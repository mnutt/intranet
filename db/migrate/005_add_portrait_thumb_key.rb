class AddPortraitThumbKey < ActiveRecord::Migration
  def self.up
    add_column "portraits", "thumbnail", :string
  end

  def self.down
    remove_column "portraits", "thumbnail"
  end
end
