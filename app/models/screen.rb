class Screen < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :screener

  attr_accessor :time

  def pretty_time
    (scheduled_at.min == 0) ? scheduled_at.strftime('%l%p') : scheduled_at.strftime('%l:%M%p') if scheduled_at
  end

  def pretty_date
    self.scheduled_at.strftime('%B %e, %Y') rescue nil
  end
end
