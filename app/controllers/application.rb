require 'google_cal'

class ApplicationController < ActionController::Base
  session :session_key => '_limedirectory_session_id'
  protect_from_forgery :secret => '1642ed052a370457b2b5f552864352fe'

  include AuthenticatedSystem
  before_filter :login_from_cookie

  before_filter :get_google_events

  def get_google_events
    @events = GoogleCal.retrieve_latest(15)
  end

  def image_path(source)
    compute_public_path(source, 'images')
  end
end
