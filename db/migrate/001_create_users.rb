class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column "login", :string
      t.column "email", :string
      t.column "crypted_password", :string, :limit => 40
      t.column "salt", :string, :limit => 40
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "portrait", :string
      t.column "bio", :text
      t.column "homepage", :string
    end
  end

  def self.down
    drop_table :users
  end
end
