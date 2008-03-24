class CompanyDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column "companies", "description", :text
  end

  def self.down
    change_column "companies", "description", :string
  end
end
