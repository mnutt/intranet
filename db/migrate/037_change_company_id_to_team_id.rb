class ChangeCompanyIdToTeamId < ActiveRecord::Migration
  def self.up
    rename_column :positions, :company_id, :team_id
  end

  def self.down
    rename_column :positions, :team_id, :company_id
  end
end
