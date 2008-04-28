require File.dirname(__FILE__) + '/../test_helper'
require 'attachments_controller'

# Re-raise errors caught by the controller.
class AttachmentsController; def rescue_action(e) raise e end; end

class AttachmentsControllerTest < Test::Unit::TestCase
  fixtures :attachments

  def setup
    @controller = AttachmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:attachments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_attachment
    assert_difference('Attachment.count') do
      post :create, :attachment => { }
    end

    assert_redirected_to attachment_path(assigns(:attachment))
  end

  def test_should_show_attachment
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_attachment
    put :update, :id => 1, :attachment => { }
    assert_redirected_to attachment_path(assigns(:attachment))
  end

  def test_should_destroy_attachment
    assert_difference('Attachment.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to attachments_path
  end
end
