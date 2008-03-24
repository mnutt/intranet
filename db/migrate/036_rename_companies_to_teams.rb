class RenameCompaniesToTeams < ActiveRecord::Migration
  def self.up
    rename_table :companies, :teams
  end

  def self.down
    rename_table :teams, :companies
  end
end
