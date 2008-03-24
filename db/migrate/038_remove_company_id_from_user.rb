class RemoveCompanyIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :company_id
  end

  def self.down
    add_column :users, :company_id, :integer
  end
end
