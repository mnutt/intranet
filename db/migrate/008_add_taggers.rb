class AddTaggers < ActiveRecord::Migration
  def self.up
    add_column "taggings", "tagger_id", :integer
  end

  def self.down
    remove_column "taggings", "tagger_id"
  end
end
