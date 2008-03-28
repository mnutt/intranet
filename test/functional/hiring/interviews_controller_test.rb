require File.dirname(__FILE__) + '/../test_helper'
require 'interviews_controller'

# Re-raise errors caught by the controller.
class InterviewsController; def rescue_action(e) raise e end; end

class InterviewsControllerTest < Test::Unit::TestCase
  fixtures :interviews

  def setup
    @controller = InterviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:interviews)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_interview
    assert_difference('Interview.count') do
      post :create, :interview => { }
    end

    assert_redirected_to interview_path(assigns(:interview))
  end

  def test_should_show_interview
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_interview
    put :update, :id => 1, :interview => { }
    assert_redirected_to interview_path(assigns(:interview))
  end

  def test_should_destroy_interview
    assert_difference('Interview.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to interviews_path
  end
end
