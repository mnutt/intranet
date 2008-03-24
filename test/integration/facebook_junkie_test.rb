require "#{File.dirname(__FILE__)}/../test_helper"

class FacebookJunkieTest < ActionController::IntegrationTest
  fixtures :users

  def test_resetting_facebook_password
    dude = facebook_user
    dude.get "/"
    dude.is_viewing("index")
    dude.logs_in
    dude.logs_out
    dude.asks_reminder
    dude.visits_reset_url
    dude.resets_password
    dude.logs_in_with_new_pw
  end
  
  def facebook_user
    open_session do |user|
      def user.is_viewing(page)
        assert_response :success
      end
      def user.logs_in
        get "/login"
        post_via_redirect "/sessions", :user => 'quentin' , :password => 'test'
        assert_response :success
        assert_template "sessions/new"
      end
      def user.logs_out
        get "/logout"
        assert_response :redirect
      end
      def user.asks_reminder
        get "/reminder"
        assert_response :success
        post_via_redirect "/users/forgot_password", :reminder => {:email=>'quentin@example.com'}
        assert_response :success
        assert_match /A password reset/, @response.body
      end
      def user.visits_reset_url
        user = User.find_by_email('quentin@example.com')
        get "/reset/#{user.password_reset_code}"
        assert_response :success
        assert_template "users/reset_password"
      end
      def user.resets_password
        post_via_redirect "/users/reset_password" , 
          :reset => {:password => 'test123', :password_confirmation=> 'test123'}
        assert_response :success
      end
      def user.logs_in_with_new_pw
        get "/login"
        post_via_redirect "/sessions", :user => 'quentin', :password => 'test123'
        assert_response :success
      end
    end
  end
end
