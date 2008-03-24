require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

 # def test_should_activate_user_and_send_activation_email
 #   get :activate, :id => users(:aaron).id, :activation_code => users(:aaron).activation_code
 #   assert_equal 1, @emails.length
 #   assert(@emails.first.subject =~ /Your account has been activated/)
 #   assert(@emails.first.body    =~ /#{assigns(:user).login}, your account has been activated/)
 # end

 # def test_should_send_activation_email_after_signup
 #   create_user
 #   assert_equal 1, @emails.length
 #   assert(@emails.first.subject =~ /Please activate your new account/)
 #   assert(@emails.first.body    =~ /Username: quire/)
 #   assert(@emails.first.body    =~ /Password: quire/)
 #   assert(@emails.first.body    =~ /users\/#{assigns(:user).id};activate\?activation_code=#{assigns(:user).activation_code}/)
 # end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
