require 'image_science'

class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  def index
    @photos = Photo.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @photos.to_xml }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @photo.to_xml }
    end
  end

  def icon
    render_thumbnail(12, false)
  end

  def raw
    @photo = Photo.find(params[:id])
    send_data(@photo.content, :type => @photo.mimetype, :disposition => "inline")
  end

  def set
    photo = Photo.find(params[:id])
    if session[:user] == photo.user_id
      photo.user.update_attributes({ :portrait_id => photo.id })
      flash[:notice] = "Successfully set this photo as your icon."
    else
      flash[:notice] = "You can't be someone else!"
    end
    redirect_to photo_url(:id => params[:id])
  end

  def custom_size
    @photo = Photo.find(params[:id])
    proportional = (params[:square] ? false : true)
    if params[:size] and params[:size].to_i < 2000 and !@photo.content.nil?
      send_data(@photo.thumbnail(params[:size].to_i, proportional),
                :type => @photo.mimetype,
                :disposition => "inline")
    else
      render :nothing => true
    end
  end

  def create
    user = session[:user]
    tempfile = params[:photo].delete("data")

    if tempfile.size == 0
      flash[:error] = "You did not specify a file to upload."
      redirect_to :action => 'workspace' and return
    end

    mime = tempfile.content_type.to_s.split("/")[0]
    @photo = Photo.new( params[:photo].merge({ :user_id => user,
                                               :name => tempfile.original_filename,
                                               :mimetype => tempfile.content_type.strip}) )

    # TODO: Why is POST in functional test not sending it multipart?
    @photo.content = tempfile.respond_to?(:read) ? tempfile.read : tempfile

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :created, :location => photo_url(@photo) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1;edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to photo_url(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors.to_xml }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url }
      format.xml  { head :ok }
    end
  end

end
