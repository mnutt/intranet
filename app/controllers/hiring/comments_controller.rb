class Hiring::CommentsController < ApplicationController
  # GET /hiring_comments
  # GET /hiring_comments.xml
  def index
    @comments = Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hiring_comments }
    end
  end

  # GET /hiring_comments/1
  # GET /hiring_comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /hiring_comments/new
  # GET /hiring_comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /hiring_comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /hiring_comments
  # POST /hiring_comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.commenter = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully added.'
        format.html { redirect_to url_for(['hiring', @comment.commentable]) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hiring_comments/1
  # PUT /hiring_comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to url_for(['hiring', @comment.commentable]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hiring_comments/1
  # DELETE /hiring_comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(hiring_comments_url) }
      format.xml  { head :ok }
    end
  end
end
