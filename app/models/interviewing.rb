class Interviewing < ActiveRecord::Base
  belongs_to :interview
  belongs_to :user

  attr_accessor :time

  before_save :set_time
  def set_time
    start_time, end_time = time.split("-")
    self.start_time = Chronic.parse("#{self.interview.pretty_date.gsub(',', '')} #{start_time}")
    self.end_time = Chronic.parse("#{self.interview.pretty_date.gsub(',', '')} #{end_time}")
  end

  def verdict_color
    case verdict
      when 'thumb_up' then
        "#BBDDFF"
      when 'thumb_down' then
        "#FFCCCC"
      when 'maybe' then
        "#EEEEEE"
      else
        "#FFFFFF"
    end
  end

  def pretty_time
    starting = start_time.min == 0 ? start_time.strftime('%l%p') : start_time.strftime('%l:%M%p')

    if end_time
      ending = end_time.min == 0 ? end_time.strftime('%l%p') : end_time.strftime('%l:%M%p')
      "#{starting}-#{ending.strip}"
    else
      starting
    end
  end
end
