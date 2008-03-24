require 'open-uri'
require 'date'
require 'yaml'

module GoogleCal
  SAVE_PATH = "#{RAILS_ROOT}/tmp/events.yaml"

  def self.retrieve_latest(num)
    if File.exist? SAVE_PATH

      return YAML.load(File.read(SAVE_PATH))
    else
      events = []
      open(SETTINGS['calendar_ics_link']) do |ical|
        ical.each_line do |line|
          line.chomp!
          if line =~ /BEGIN:VEVENT/
            events << {}
          elsif line =~ /DT(START|END);VALUE=DATE:(.*)/
            events.last[$1.downcase] = DateTime.parse($2) if $2
          elsif line =~ /DT(START|END);TZID=([^:]*):(.*)/
            events.last[$1.downcase] = DateTime.parse($3) if $3
          elsif line =~ /SUMMARY:(.*)/
            events.last['task'] = $1
          end
        end
      end

      User.find(:all).each do |u|
        next unless u.birthday
        dob = u.birthday.to_time
        birthday = DateTime.parse("#{Time.now.year}-#{dob.month}-#{dob.day} 0:00")
        event = {}
        event['start'] = birthday
        event['end'] = birthday + 1
        event['task'] = "#{u.login}'s birthday"
        events << event
        birthday = DateTime.parse("#{Time.now.year + 1}-#{dob.month}-#{dob.day} 0:00")
        event = {}
        event['start'] = birthday
        event['end'] = birthday + 1
        event['task'] = "#{u.login}'s birthday"
        events << event
      end

      events.reject! { |e| e['start'].nil? or e['end'].nil? or e['end'] < DateTime.now }
      events = events.sort_by{ |e| e['start'] }

      File.open(SAVE_PATH, "w") do |f|
        f.write(events.first(num).to_yaml)
      end

      return YAML.load(File.read(SAVE_PATH))
    end
  rescue
    return []
  end
end

