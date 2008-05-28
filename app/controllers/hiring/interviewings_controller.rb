class Hiring::InterviewingsController < ApplicationController
  # GET /interviews
  # GET /interviews.xml
  def index
    @interviewings = Interviewing.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interviewings }
    end
  end

  # GET /interviewings/1
  # GET /interviewings/1.xml
  def show
    @interviewing = Interviewing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interviewing }
    end
  end

  # GET /interviewings/new
  # GET /interviewings/new.xml
  def new
    @interviewing = Interviewing.new
    @interviewing.interview = Interview.find params[:interview_id]
    if !@interviewing.interview.interviewings.empty?
      start = @interviewing.interview.interviewings.find(:first, :order => "end_time DESC")
      @interviewing.start_time = start.end_time
      @interviewing.end_time = start.end_time + 1.hour
    else
      @interviewing.start_time = Chronic.parse("tomorrow at 11am")
      @interviewing.end_time = Chronic.parse("tomorrow at 12pm")
    end

    @user_choices = User.find(:all).map {|u| [u.login, u.id] }
    @user_choices.unshift(["Lunch", 0])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interviewing }
    end
  end

  # GET /interviewings/1/edit
  def edit
    @interviewing = Interviewing.find(params[:id])
  end

  # POST /interviewings
  # POST /interviewings.xml
  def create
    @interviewing = Interviewing.new(params[:interviewing])
    @interviewing.is_other = true if params[:interviewing] and params[:interviewing][:user_id] == "0"


    respond_to do |format|
      if @interviewing.save
        flash[:notice] = 'Interviewing was successfully created.'
        format.html { redirect_to hiring_interview_url(@interviewing.interview) }
        format.xml  { render :xml => @interviewing, :status => :created, :location => @interviewing }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interviewing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interviewings/1
  # PUT /interviewings/1.xml
  def update
    @interviewing = Interviewing.find(params[:id])

    respond_to do |format|
      if @interviewing.update_attributes(params[:interviewing])
        flash[:notice] = 'Interviewing was successfully updated.'
        format.html { redirect_to hiring_interview_url(@interviewing.interview) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interviewing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interviewings/1
  # DELETE /interviewings/1.xml
  def destroy
    @interviewing = Interviewing.find(params[:id])
    @interviewing.destroy

    respond_to do |format|
      format.html { redirect_to(hiring_interviewings_url) }
      format.xml  { head :ok }
    end
  end
end
