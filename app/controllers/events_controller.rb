class EventsController < ApplicationController
  def out
    FileUtils.rm("#{RAILS_ROOT}/tmp/events.yaml") if File.exist?("#{RAILS_ROOT}/tmp/events.yaml")
    @out = GoogleCal.retrieve_latest(15).select{|e| e['start'] < Time.now && e['end'] > Time.now && (e['task'] =~ /out/ || e['task'] =~ /vacation/) rescue nil}.map{|e| e['task'] }
  end
end
