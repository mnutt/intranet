require File.dirname(__FILE__) + '/../test_helper'
require 'marks_controller'

# Re-raise errors caught by the controller.
class MarksController; def rescue_action(e) raise e end; end

class MarksControllerTest < Test::Unit::TestCase
  fixtures :marks

  def setup
    @controller = MarksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:marks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_mark
    old_count = Mark.count
    post :create, :mark => { }
    assert_equal old_count+1, Mark.count
    
    assert_redirected_to mark_path(assigns(:mark))
  end

  def test_should_show_mark
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_mark
    put :update, :id => 1, :mark => { }
    assert_redirected_to mark_path(assigns(:mark))
  end
  
  def test_should_destroy_mark
    old_count = Mark.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Mark.count
    
    assert_redirected_to marks_path
  end
end
