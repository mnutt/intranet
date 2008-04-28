class AddResumeColumnsToCandidate < ActiveRecord::Migration
  def self.up
    add_column :candidates, :resume_file_name, :string  
    add_column :candidates, :resume_content_type, :string  
    add_column :candidates, :resume_file_size, :integer  
  end

  def self.down
    remove_column :candidates, :resume_file_size  
    remove_column :candidates, :resume_content_type  
    remove_column :candidates, :resume_file_name  
  end
end
