class CachePortraitUrls < ActiveRecord::Migration
  def self.up
    add_column "users", "portrait_url", :string
    add_column "users", "portrait_thumbnail_url", :string
  end

  def self.down
    remove_column "users", "portrait_url"
    remove_column "users", "portrait_thumbnail_url"
  end
end
