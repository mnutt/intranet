require File.dirname(__FILE__) + '/../../test_helper'
require 'hiring/candidates_controller'

# Re-raise errors caught by the controller.
class Hiring::CandidatesController; def rescue_action(e) raise e end; end

class Hiring::CandidatesControllerTest < Test::Unit::TestCase
  fixtures :candidates

  def setup
    @controller = Hiring::CandidatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:candidates)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_candidate
    assert_difference('Candidate.count') do
      post :create, :candidate => { }
    end

    assert_redirected_to hiring_candidate_path(assigns(:candidate))
  end

  def test_should_show_candidate
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_candidate
    put :update, :id => 1, :candidate => { }
    assert_redirected_to hiring_candidate_path(assigns(:candidate))
  end

  def test_should_destroy_candidate
    assert_difference('Candidate.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to hiring_candidates_path
  end
end
