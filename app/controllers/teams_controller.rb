class TeamsController < ApplicationController
   before_filter :admin_required, :except => [ :index, :show ]
  # GET /teams
  # GET /teams.xml
  def index
    @teams = Team.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @teams.to_xml }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find_by_name(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @team.to_xml }
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1;edit
  def edit
    @team = Team.find_by_name(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to team_url(@team) }
        format.xml  { head :created, :location => team_url(@team) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors.to_xml }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find_by_name(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to team_url(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors.to_xml }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find_by_name(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.xml  { head :ok }
    end
  end
end
