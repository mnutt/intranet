class AddStuffToPositions < ActiveRecord::Migration
  def self.up
    rename_column "users", "company", "company_id"
    add_column "positions", "company_id", :integer
    add_column "positions", "user_id", :integer
  end

  def self.down
  end
end
