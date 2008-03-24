require 'chronic'

class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create, :reminder, :forgot_password, :reset_password, :reset, :create_position, :delete_position]
  before_filter :login_required, :except => [ :index, :show, :new, :create, :activate, :reminder, :forgot_password, :reset_password, :reset]

  def index
    order = case params[:order]
      when "newest"
        'users.created_at desc'
      when "first"
        'login'
      when "last"
        "SUBSTRING_INDEX(users.login,' ',-1) ASC"
    end

    if params[:commit] == "search"
      @users = User.search(params[:q].split.collect{ |c| c.downcase })
      if @users.size == 1
        redirect_to user_url(@users.first)
      end
    else
      @users = User.find :all, :conditions => { :former => false }, :order => order, :include => [:portrait]
    end

    respond_to do |accepts|
      accepts.html do
        render :action => 'list' if params[:style] == 'list'
      end
      accepts.vcf { render :template => 'users/index.vcf', :layout => false }
      accepts.xml { render :template => 'users/index.xml.erb' }
    end
  end

  def show
    respond_to do |accepts|
      accepts.html
      accepts.vcf { render :template => 'users/show.vcf', :layout => false }
      accepts.xml { render :xml => @user.to_xml }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    flash[:notice] = "Thanks for signing up! Please take a moment to fill out some info."
    redirect_to edit_user_path(@user)
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @users = User.find(:all, :conditions => ['id != ?', @user.id])
  end

  def update
    params[:user][:birthday] = Chronic.parse(params[:user][:birthday].gsub(",","")) if params[:user][:birthday]
    @user.attributes = params[:user]
    @user.save!
    respond_to do |accepts|
      accepts.html do
        flash[:notice] = "User was saved."
        redirect_to user_url(:id => @user)
      end
      accepts.xml do
        render :nothing => true, :status => '204 No Content'
      end
    end
  rescue ActiveRecord::RecordInvalid
    @users = User.find(:all, :conditions => ['id != ?', @user.id])
    respond_to do |accepts|
      accepts.html do
        flash[:notice] = "User was not saved."
        render :action => 'edit'
      end
      accepts.xml do
        render :status => '400 Validation Failed', :xml => @user.errors.to_xml
      end
    end
  end

  def activate
    if @user.activation_code == params[:activation_code] and @user.activate
      self.current_user = @user
      redirect_to user_path(@user)
      flash[:notice] = "Your account has been activated."
    end
  end

 def destroy
   @user.destroy
   respond_to do |accepts|
     accepts.html do
       flash[:notice] = "User was deleted."
       redirect_to '/'
     end
     accepts.xml do
       render :nothing => true, :status => '204 No Content'
     end
   end
 end

 def reminder
   render :template => 'users/forgot_password'
 end

 def reset
   render :action => 'users/reset_password'
 end

 def forgot_password
   return unless request.post?
   if @user = User.find_by_email(params[:reminder][:email])
     @user.forgot_password
     @user.save
     redirect_back_or_default(:controller => '/login', :action => 'index')
     flash[:notice] = "A password reset link has been sent to your email address, please check and come back"
   else
     flash[:notice] = "Could not find a user with that email address"
   end
 end

 def reset_password
     @user = User.find_by_password_reset_code(params[:reset][:key])
     return if @user unless params[:reset][:password]
     if (params[:reset][:password] == params[:reset][:password_confirmation])
       if @user.nil?
         flash[:notice] = 'Could not find that user..wtf? I guess you have an old reset key.'
         return
       end
       self.current_user = @user #for the next two lines to work
       # breakpoint
       current_user.password_confirmation = params[:reset][:password_confirmation]
       current_user.password = params[:reset][:password]
       @user.reset_password
       @user.activate unless @user.activated_at # User came here from email, so activate 'em

       flash[:notice] = current_user.save ? "Password reset, go login" : "Password not reset"
     else
       flash[:notice] = "Password mismatch"
     end
      # redirect_back_or_default(:action => 'reset')
      redirect_back_or_default(:controller => '/login', :action => 'index')
 end

protected
  def find_user
    @user ||= User.find_by_login(params[:id])
  end

  def protect?
  end

  def authorized?
    action_name == 'show' or current_user == @user
  end
end
