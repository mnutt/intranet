# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION
require 'rubygems'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  config.action_controller.session = {
    :session_key => '_limedirectory_session',
    :secret      => '1642ed052a370457b2b5f552864352fe'
  }

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
ActiveRecord::Base.class_eval do
  def dom_id
    [self.class.name.underscore, id] * '-'
  end

  ActionMailer::Base.smtp_settings = {
    :address => "cyrus.limewire.com",
    :port => 25,
    :domain => "limewire.com"
  }
end

Mime::Type.register "text/x-vcard", :vcf

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :event => "%a, %b %e at %l:%M%P",
  :nice => "%b %e",
  :post_html => "<span class='month'>%b</span><span class='day'>%e</span><span class='comma'>,</span><span class='year'>%Y</span>",
  :post => "%b %e - %Y %l:%M%P",
  :time => "%l:%M%P",
  :today => "Today at %l:%M%P",
  :tomorrow => "Tomorrow at %l:%M%P",
  :yesterday => "Yesterday at %l:%M%P"
)

settings_file = "#{RAILS_ROOT}/config/settings.yml"
if File.exist?(settings_file)
  SETTINGS = YAML::load_file(settings_file)
end
SETTINGS ||= {}

$:.push(*Dir["tmp/gems/*"])

require 'vendor/plugins/gems/init'
require 'chronic'
require 'mime/types'
require 'redcloth'
require 'image_science'
