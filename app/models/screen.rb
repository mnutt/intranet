class Screen < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :user

  def pretty_time
    starting = start_time.min == 0 ? start_time.strftime('%l%p') : start_time.strftime('%l:%M%p')
    ending = end_time.min == 0 ? end_time.strftime('%l%p') : end_time.strftime('%l:%M%p')
    "#{starting}-#{ending.strip}"
  end
end
