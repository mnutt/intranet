require File.dirname(__FILE__) + '/../../test_helper'
require 'hiring/interviews_controller'

# Re-raise errors caught by the controller.
class Hiring::InterviewsController; def rescue_action(e) raise e end; end

class Hiring::InterviewsControllerTest < Test::Unit::TestCase
  fixtures :interviews

  def setup
    @controller = Hiring::InterviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:interviews)
  end

  def test_should_get_new
    get :new, :candidate_id => 1
    assert_response :success
  end

  def test_should_create_interview
    assert_difference('Interview.count') do
      post :create, :candidate_id => 1, :interview => { :scheduled_at => "tomorrow at 10am" }
    end

    assert_redirected_to hiring_interview_path(assigns(:interview))
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
    assert_redirected_to hiring_interview_path(assigns(:interview))
  end

  def test_should_destroy_interview
    assert_difference('Interview.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to hiring_interviews_path
  end
end
