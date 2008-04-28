class Interview < ActiveRecord::Base
  belongs_to :candidate
  has_many :interviewings, :order => 'start_time ASC'

  def pretty_date
    self.scheduled_at.strftime('%B %e, %Y') rescue nil
  end
end
