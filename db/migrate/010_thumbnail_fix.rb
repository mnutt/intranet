class ThumbnailFix < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user|
      if user.portrait and File.exists?(user.portrait.full_filename)
        user.portrait.thumbnails.clear
        user.portrait.attachment_data # loads the file into memory so we can generate the thumbnail
        user.portrait.instance_variable_set(:@save_attachment, true)
        user.portrait.save
        user.portrait(true)
        user.portrait_thumbnail_url = user.portrait.thumbnails.first.url rescue nil
        user.save
      end
    end
  end
 def self.down
    User.find(:all).each do |user|
      user.portrait_thumbnail_url = user.portrait.thumbnails.first.url rescue nil
      user.save
    end
  end
end
