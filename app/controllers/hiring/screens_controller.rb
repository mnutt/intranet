class Hiring::ScreensController < ApplicationController
  # GET /screens
  # GET /screens.xml
  def index
    @screens = Screen.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @screens }
    end
  end

  # GET /screens/1
  # GET /screens/1.xml
  def show
    @screen = Screen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @screen }
    end
  end

  # GET /screens/new
  # GET /screens/new.xml
  def new
    @screen = Screen.new
    @screen.candidate = Candidate.find params[:candidate_id] if params[:candidate_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @screen }
    end
  end

  # GET /screens/1/edit
  def edit
    @screen = Screen.find(params[:id])
  end

  # POST /screens
  # POST /screens.xml
  def create
    @screen = Screen.new(params[:screen])
    @screen.scheduled_at = Chronic.parse(params[:screen][:scheduled_at].gsub(',', ''))

    respond_to do |format|
      if @screen.save
        flash[:notice] = 'Screen was successfully created.'
        format.html { redirect_to hiring_screen_url(@screen) }
        format.xml  { render :xml => @screen, :status => :created, :location => @screen }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @screen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /screens/1
  # PUT /screens/1.xml
  def update
    @screen = Screen.find(params[:id])

    respond_to do |format|
      if @screen.update_attributes(params[:screen])
        flash[:notice] = 'Screen was successfully updated.'
        format.html { redirect_to hiring_screen_url(@screen) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @screen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /screens/1
  # DELETE /screens/1.xml
  def destroy
    @screen = Screen.find(params[:id])
    @screen.destroy

    respond_to do |format|
      format.html { redirect_to(hiring_screens_url) }
      format.xml  { head :ok }
    end
  end
end
