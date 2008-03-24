class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column "users", "birthday", :date
    add_column "users", "cell", :string
    add_column "users", "extension", :string
    add_column "users", "aim", :string
    add_column "users", "yahoo", :string
    add_column "users", "msn", :string
  end

  def self.down
    remove_column "users", "birthday"
    remove_column "users", "cell"
    remove_column "users", "extension"
    remove_column "users", "aim"
    remove_column "users", "yahoo"
    remove_column "users", "msn"
  end
end
