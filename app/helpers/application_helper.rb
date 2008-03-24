# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def event_formatted_time(time)
    time -= 2.hours # timezone difference?
    format = case
             when time < 1.day.ago.at_midnight       then :event
             when time < Time.now.at_midnight        then :yesterday
             when time < 1.day.from_now.at_midnight  then :today
             when time < 2.days.from_now.at_midnight then :tomorrow
             else :event
             end

    time.to_formatted_s format
  end

  def image_path(source)
    compute_public_path(source, 'images', '')
  end
end
