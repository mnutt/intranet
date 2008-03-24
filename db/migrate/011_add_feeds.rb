class AddFeeds < ActiveRecord::Migration
  def self.up
    add_column "users", "feed", :string
    add_column "users", "planet", :boolean
  end

  def self.down
    remove_column "users", "feed"
    remove_column "users", "planet"
  end
end
