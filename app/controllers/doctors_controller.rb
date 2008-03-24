class DoctorsController < ApplicationController
  # GET /doctors
  # GET /doctors.xml
  def index
    @doctors = Doctor.find(:all, :conditions => {:type => nil})

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @doctors.to_xml }
    end
  end

  # GET /doctors/1
  # GET /doctors/1.xml
  def show
    @doctor = Doctor.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @doctor.to_xml }
    end
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
  end

  # GET /doctors/1;edit
  def edit
    @doctor = Doctor.find(params[:id])
  end

  # POST /doctors
  # POST /doctors.xml
  def create
    @doctor = Doctor.new(params[:doctor])

    respond_to do |format|
      if @doctor.save
        flash[:notice] = 'Doctor was successfully created.'
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :created, :location => doctor_url(@doctor) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

  # PUT /doctors/1
  # PUT /doctors/1.xml
  def update
    @doctor = Doctor.find(params[:id])

    respond_to do |format|
      if @doctor.update_attributes(params[:doctor])
        flash[:notice] = 'Doctor was successfully updated.'
        format.html { redirect_to doctor_url(@doctor) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doctor.errors.to_xml }
      end
    end
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.xml
  def destroy
    @doctor = Doctor.find(params[:id])
    @doctor.destroy

    respond_to do |format|
      format.html { redirect_to doctors_url }
      format.xml  { head :ok }
    end
  end
end
