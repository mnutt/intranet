class AddPhoneNumberToDoctors < ActiveRecord::Migration
  def self.up
    add_column :doctors, :phone_number, :string
    add_column :doctors, :type, :string
  end

  def self.down
    remove_column :doctors, :phone_number
    remove_column :doctors, :type
  end
end
