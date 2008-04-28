class Hiring::InterviewsController < ApplicationController
  # GET /interviews
  # GET /interviews.xml
  def index
    @interviews = Interview.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interviews }
    end
  end

  # GET /interviews/1
  # GET /interviews/1.xml
  def show
    @interview = Interview.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interview }
    end
  end

  # GET /interviews/new
  # GET /interviews/new.xml
  def new
    @interview = Interview.new
    @interview.candidate = Candidate.find params[:candidate_id] if params[:candidate_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interview }
    end
  end

  # GET /interviews/1/edit
  def edit
    @interview = Interview.find(params[:id])
  end

  # POST /interviews
  # POST /interviews.xml
  def create
    @interview = Interview.new(params[:interview])
    @interview.scheduled_at = Chronic.parse(params[:interview][:scheduled_at].gsub(',', ''))

    respond_to do |format|
      if @interview.save
        flash[:notice] = 'Interview was successfully created.'
        format.html { redirect_to hiring_interview_url(@interview) }
        format.xml  { render :xml => @interview, :status => :created, :location => @interview }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interviews/1
  # PUT /interviews/1.xml
  def update
    @interview = Interview.find(params[:id])

    respond_to do |format|
      if @interview.update_attributes(params[:interview])
        flash[:notice] = 'Interview was successfully updated.'
        format.html { redirect_to hiring_interview_url(@interview) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interview.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.xml
  def destroy
    @interview = Interview.find(params[:id])
    @interview.destroy

    respond_to do |format|
      format.html { redirect_to(hiring_interviews_url) }
      format.xml  { head :ok }
    end
  end
end
