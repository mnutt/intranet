require File.dirname(__FILE__) + '/../../test_helper'
require 'hiring/comments_controller'

# Re-raise errors caught by the controller.
class Hiring::CommentsController; def rescue_action(e) raise e end; end

class Hiring::CommentsControllerTest < Test::Unit::TestCase
  fixtures :hiring_comments

  def setup
    @controller = Hiring::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:hiring_comments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_comment
    assert_difference('Hiring::Comment.count') do
      post :create, :comment => { }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  def test_should_show_comment
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_comment
    put :update, :id => 1, :comment => { }
    assert_redirected_to comment_path(assigns(:comment))
  end

  def test_should_destroy_comment
    assert_difference('Hiring::Comment.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to hiring_comments_path
  end
end
