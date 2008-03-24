require File.dirname(__FILE__) + '/../abstract_unit'

uses_mocha 'rescue' do

class RescueController < ActionController::Base
  class NotAuthorized < StandardError
  end

  class RecordInvalid < StandardError
  end

  rescue_from NotAuthorized, :with => :deny_access
  rescue_from RecordInvalid, :with => :show_errors

  def raises
    render :text => 'already rendered'
    raise "don't panic!"
  end

  def method_not_allowed
    raise ActionController::MethodNotAllowed.new(:get, :head, :put)
  end
  
  def not_implemented
    raise ActionController::NotImplemented.new(:get, :put)
  end

  def not_authorized
    raise NotAuthorized
  end

  def record_invalid
    raise RecordInvalid
  end
  
  def missing_template
  end

  protected
    def deny_access
      head :forbidden
    end

    def show_errors(exception)
      head :unprocessable_entity
    end
end

class RescueTest < Test::Unit::TestCase
  FIXTURE_PUBLIC = "#{File.dirname(__FILE__)}/../fixtures".freeze

  def setup
    @controller = RescueController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    RescueController.consider_all_requests_local = true
    @request.remote_addr = '1.2.3.4'
    @request.host = 'example.com'

    begin
      raise 'foo'
    rescue => @exception
    end
  end

  def test_rescue_action_locally_if_all_requests_local
    @controller.expects(:local_request?).never
    @controller.expects(:rescue_action_locally).with(@exception)
    @controller.expects(:rescue_action_in_public).never

    with_all_requests_local do
      @controller.send :rescue_action, @exception
    end
  end

  def test_rescue_action_locally_if_remote_addr_is_localhost
    @controller.expects(:local_request?).returns(true)
    @controller.expects(:rescue_action_locally).with(@exception)
    @controller.expects(:rescue_action_in_public).never

    with_all_requests_local false do
      @controller.send :rescue_action, @exception
    end
  end

  def test_rescue_action_in_public_otherwise
    @controller.expects(:local_request?).returns(false)
    @controller.expects(:rescue_action_locally).never
    @controller.expects(:rescue_action_in_public).with(@exception)

    with_all_requests_local false do
      @controller.send :rescue_action, @exception
    end
  end

  def test_rescue_action_in_public_with_error_file
    with_rails_root FIXTURE_PUBLIC do
      with_all_requests_local false do
        get :raises
      end
    end

    assert_response :internal_server_error
    body = File.read("#{FIXTURE_PUBLIC}/public/500.html")
    assert_equal body, @response.body
  end

  def test_rescue_action_in_public_without_error_file
    with_rails_root '/tmp' do
      with_all_requests_local false do
        get :raises
      end
    end

    assert_response :internal_server_error
    assert_equal ' ', @response.body
  end

  def test_rescue_unknown_action_in_public_with_error_file
    with_rails_root FIXTURE_PUBLIC do
      with_all_requests_local false do
        get :foobar_doesnt_exist
      end
    end

    assert_response :not_found
    body = File.read("#{FIXTURE_PUBLIC}/public/404.html")
    assert_equal body, @response.body
  end

  def test_rescue_unknown_action_in_public_without_error_file
    with_rails_root '/tmp' do
      with_all_requests_local false do
        get :foobar_doesnt_exist
      end
    end

    assert_response :not_found
    assert_equal ' ', @response.body
  end

  def test_rescue_missing_template_in_public
    with_rails_root FIXTURE_PUBLIC do
      with_all_requests_local true do
        get :missing_template
      end
    end

    assert_response :internal_server_error
    assert @response.body.include?('missing_template'), "Response should include the template name."
  end

  def test_rescue_action_locally
    get :raises
    assert_response :internal_server_error
    assert_template 'diagnostics.erb'
    assert @response.body.include?('RescueController#raises'), "Response should include controller and action."
    assert @response.body.include?("don't panic"), "Response should include exception message."
  end

  def test_local_request_when_remote_addr_is_localhost
    @controller.expects(:request).returns(@request).at_least_once
    with_remote_addr '127.0.0.1' do
      assert @controller.send(:local_request?)
    end
  end

  def test_local_request_when_remote_addr_isnt_locahost
    @controller.expects(:request).returns(@request)
    with_remote_addr '1.2.3.4' do
      assert !@controller.send(:local_request?)
    end
  end

  def test_rescue_responses
    responses = ActionController::Base.rescue_responses

    assert_equal ActionController::Rescue::DEFAULT_RESCUE_RESPONSE, responses.default
    assert_equal ActionController::Rescue::DEFAULT_RESCUE_RESPONSE, responses[Exception.new]

    assert_equal :not_found, responses[ActionController::RoutingError.name]
    assert_equal :not_found, responses[ActionController::UnknownAction.name]
    assert_equal :not_found, responses['ActiveRecord::RecordNotFound']
    assert_equal :conflict, responses['ActiveRecord::StaleObjectError']
    assert_equal :unprocessable_entity, responses['ActiveRecord::RecordInvalid']
    assert_equal :unprocessable_entity, responses['ActiveRecord::RecordNotSaved']
    assert_equal :method_not_allowed, responses['ActionController::MethodNotAllowed']
    assert_equal :not_implemented, responses['ActionController::NotImplemented']
  end

  def test_rescue_templates
    templates = ActionController::Base.rescue_templates

    assert_equal ActionController::Rescue::DEFAULT_RESCUE_TEMPLATE, templates.default
    assert_equal ActionController::Rescue::DEFAULT_RESCUE_TEMPLATE, templates[Exception.new]

    assert_equal 'missing_template',  templates[ActionController::MissingTemplate.name]
    assert_equal 'routing_error',     templates[ActionController::RoutingError.name]
    assert_equal 'unknown_action',    templates[ActionController::UnknownAction.name]
    assert_equal 'template_error',    templates[ActionView::TemplateError.name]
  end

  def test_clean_backtrace
    with_rails_root nil do
      # No action if RAILS_ROOT isn't set.
      cleaned = @controller.send(:clean_backtrace, @exception)
      assert_equal @exception.backtrace, cleaned
    end

    with_rails_root Dir.pwd do
      # RAILS_ROOT is removed from backtrace.
      cleaned = @controller.send(:clean_backtrace, @exception)
      expected = @exception.backtrace.map { |line| line.sub(RAILS_ROOT, '') }
      assert_equal expected, cleaned

      # No action if backtrace is nil.
      assert_nil @controller.send(:clean_backtrace, Exception.new)
    end
  end
  
  def test_not_implemented
    with_all_requests_local false do
      head :not_implemented
    end
    assert_response :not_implemented
    assert_equal "GET, PUT", @response.headers['Allow']
  end

  def test_method_not_allowed
    with_all_requests_local false do
      get :method_not_allowed
    end
    assert_response :method_not_allowed
    assert_equal "GET, HEAD, PUT", @response.headers['Allow']
  end

  def test_rescue_handler
    get :not_authorized
    assert_response :forbidden
  end

  def test_rescue_handler_with_argument
    @controller.expects(:show_errors).once.with { |e| e.is_a?(Exception) }
    get :record_invalid
  end

  protected
    def with_all_requests_local(local = true)
      old_local, ActionController::Base.consider_all_requests_local =
        ActionController::Base.consider_all_requests_local, local
      yield
    ensure
      ActionController::Base.consider_all_requests_local = old_local
    end

    def with_remote_addr(addr)
      old_remote_addr, @request.remote_addr = @request.remote_addr, addr
      yield
    ensure
      @request.remote_addr = old_remote_addr
    end

    def with_rails_root(path = nil)
      old_rails_root = RAILS_ROOT if defined?(RAILS_ROOT)
      if path
        silence_warnings { Object.const_set(:RAILS_ROOT, path) }
      else
        Object.remove_const(:RAILS_ROOT) rescue nil
      end

      yield

    ensure
      if old_rails_root
        silence_warnings { Object.const_set(:RAILS_ROOT, old_rails_root) }
      else
        Object.remove_const(:RAILS_ROOT) rescue nil
      end
    end
end

end # uses_mocha
