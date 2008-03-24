class DentistsController < ApplicationController
  # GET /dentists
  # GET /dentists.xml
  def index
    @dentists = Dentist.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @dentists.to_xml }
    end
  end

  # GET /dentists/1
  # GET /dentists/1.xml
  def show
    @dentist = Dentist.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @dentist.to_xml }
    end
  end

  # GET /dentists/new
  def new
    @dentist = Dentist.new
  end

  # GET /dentists/1;edit
  def edit
    @dentist = Dentist.find(params[:id])
  end

  # POST /dentists
  # POST /dentists.xml
  def create
    @dentist = Dentist.new(params[:dentist])

    respond_to do |format|
      if @dentist.save
        flash[:notice] = 'Dentist was successfully created.'
        format.html { redirect_to dentist_url(@dentist) }
        format.xml  { head :created, :location => dentist_url(@dentist) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dentist.errors.to_xml }
      end
    end
  end

  # PUT /dentists/1
  # PUT /dentists/1.xml
  def update
    @dentist = Dentist.find(params[:id])

    respond_to do |format|
      if @dentist.update_attributes(params[:dentist])
        flash[:notice] = 'Dentist was successfully updated.'
        format.html { redirect_to dentist_url(@dentist) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dentist.errors.to_xml }
      end
    end
  end

  # DELETE /dentists/1
  # DELETE /dentists/1.xml
  def destroy
    @dentist = Dentist.find(params[:id])
    @dentist.destroy

    respond_to do |format|
      format.html { redirect_to dentists_url }
      format.xml  { head :ok }
    end
  end
end
