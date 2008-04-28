class Candidate < ActiveRecord::Base
  has_many :comments, :as => :commentable
  has_many :interviews
  has_many :screens

  has_attached_file :resume

  def self.resume_submitted(size=20)
    find(:all,
         :limit => size,
         :order => 'created_at DESC',
         :conditions => {:status => 'resumesubmitted'})
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
    activity = []
    self.interviews.each do |interview|
      item = { :type => :interview,
               :text => "Interview",
               :object => interview,
               :date => interview.scheduled_at }
      activity << item
    end
    activity
  end
end
