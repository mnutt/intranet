class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :notes, :text
      t.column :position, :string
      t.column :website, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
