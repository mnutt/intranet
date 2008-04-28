class AddPhoneNumberToCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :phone_number, :string  
  end

  def self.down
    remove_column :candidates, :phone_number  
  end
end
