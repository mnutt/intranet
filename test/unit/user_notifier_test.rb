require File.dirname(__FILE__) + '/../test_helper'
require 'user_notifier'

class UserNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  fixtures :users
  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    # @reminder = User.forgot_password(:email => 'quentin@example.com')
  end

  def test_reset_password_mail_is_sent
    user = users(:quentin)
    response = UserNotifier.create_forgot_password(user)
    assert_equal "[lime directory] Request to change your password", response.subject
    assert_match /#{user.password_reset_code}/, response.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
