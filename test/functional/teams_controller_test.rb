require File.dirname(__FILE__) + '/../test_helper'
require 'teams_controller'

# Re-raise errors caught by the controller.
class TeamsController; def rescue_action(e) raise e end; end

class TeamsControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  fixtures :teams, :users

  def setup
    @quentin = User.find_by_login("Quentin Tarantino")
    @controller = TeamsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:teams)
  end

  def test_should_get_new
    login_as("quentin")

    get :new
    assert_response :success
  end

  def test_should_create_team
    old_count = Team.count

    login_as("quentin")

    post :create, :team => { :name => "Another Lime",
                                :description => "What do we do?" }

    assert_equal old_count+1, Team.count

    assert_redirected_to team_path(assigns(:team))
  end

  def test_should_show_team
    get :show, :id => "Lime Wire"
    assert_response :success
  end

  def test_should_get_edit
    login_as("quentin")

    get :edit, :id => "Lime Wire"
    assert_response :success
  end

  def test_should_update_team
    login_as("quentin")

    put :update, :id => "Lime Wire"
    assert_redirected_to team_path(assigns(:team))
  end

  def test_should_destroy_team
    assert Team.find(1)
    login_as("quentin")

    old_count = Team.count
    delete :destroy, :id => "Lime Wire"
    assert_equal old_count-1, Team.count

    assert_redirected_to teams_path
  end
end
