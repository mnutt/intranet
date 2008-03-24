class RMagickToImageScience < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user|
      next if user.portrait_url.blank?

      File.open("#{RAILS_ROOT}/public#{user.portrait_url}", 'r') do |p|
        photo = Photo.new(:user_id => user.id,
                          :name => File.basename(user.portrait_url),
                          :mimetype => `file -ib #{p.path}`.strip)
        photo.content = p.read
        photo.save!
        puts "Saved photo #{File.basename(user.portrait_url)}"
        user.update_attributes({ :portrait_id => photo.id })
      end
    end
  end

  def self.down
  end
end
