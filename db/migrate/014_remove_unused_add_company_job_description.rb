class RemoveUnusedAddCompanyJobDescription < ActiveRecord::Migration
  def self.up
    remove_column "users", "planet"
    remove_column "users", "feed"
    remove_column "users", "homepage"
    add_column "users", "company", :integer
    add_column "users", "job_description", :text
  end

  def self.down
    add_column "users", "planet", :boolean
    add_column "users", "feed", :string
    add_column "users", "homepage", :string
    remove_column "users", "company"
    remove_column "users", "job_description"
  end
end
