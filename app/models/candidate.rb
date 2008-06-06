class Candidate < ActiveRecord::Base
  has_many :comments, :as => :commentable
  has_many :interviews
  has_many :screens
  has_many :homeworks

  has_attached_file :resume

  def self.resume_submitted(size=20)
    find(:all,
         :limit => size,
         :order => 'created_at DESC',
         :conditions => {:status => nil})
  end

  def self.pending(size=20)
    find(:all,
         :limit => size,
         :order => 'created_at DESC',
         :conditions => {:status => 'pending'})
  end

  def self.accepted(size=20)
    find(:all,
         :limit => size,
         :order => 'created_at DESC',
         :conditions => {:status => 'accepted'})
  end

  def self.rejected(size=20)
    find(:all,
         :limit => size,
         :order => 'created_at DESC',
         :conditions => {:status => 'rejected'})
  end

  def name
    "#{first_name} #{last_name}"
  end

  def activity
    @activity ||= [interviews + homeworks + screens].flatten.compact.sort_by { |a| a.scheduled_at || a.created_at }
  end
end
