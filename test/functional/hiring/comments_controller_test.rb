require File.dirname(__FILE__) + '/../../test_helper'
require 'hiring/comments_controller'

# Re-raise errors caught by the controller.
class Hiring::CommentsController; def rescue_action(e) raise e end; end

class Hiring::CommentsControllerTest < Test::Unit::TestCase
  fixtures :comments, :candidates

  def setup
    @controller = Hiring::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  def test_should_get_new
    get :new, :candidate_id => 1
    assert_response :success
  end

  def test_should_create_comment
    assert_difference('Comment.count') do
      post :create, :comment => { :commentable_type => 'Candidate',
                                  :commentable_id => 1,
                                  :commenter_id => 1 }
    end

    assert_redirected_to hiring_candidate_path(assigns(:comment).commentable)
  end

  def test_should_show_comment
    get :show, :id => 1
    assert_response :success
    assert assigns(:comment) == Comment.find(1)
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
    assert assigns(:comment) == Comment.find(1)
  end

  def test_should_update_comment
    put :update, :candidate_id => 1, :comment => { :commentable_type => 'Candidate',
                                                   :commentable_id => 1 }
    assert_redirected_to hiring_candidate_path(Comment.find(1).commentable)
  end

  def test_should_destroy_comment
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to hiring_comments_path
  end
end
