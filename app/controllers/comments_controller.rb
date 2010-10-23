class CommentsController < ApplicationController
  layout :set_layout
  
  before_filter :require_user
  before_filter :get_commentable
  
  # GET /comments
  # GET /comments.xml
  # def index
  #   @comments = Comment.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @comments }
  #   end
  # end

  # GET /comments/1
  # GET /comments/1.xml
  # def show
  #   @comment = Comment.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @comment }
  #   end
  # end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = @commentable.comments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  # def edit
  #   @comment = Comment.find(params[:id])
  # end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @commentable.comments.new(params[:comment].merge(:person_id => current_person.id))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(notice_url(@commentable.notice), :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  # def update
  #   @comment = Comment.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @comment.update_attributes(params[:comment])
  #       format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  # def destroy
  #   @comment = Comment.find(params[:id])
  #   @comment.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(comments_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
  private
  
  def set_layout
    current_user.role
  end
  
  def get_commentable
    @commentable = Notice.find(params[:notice_id]) unless params[:notice_id].blank?
    @commentable = Comment.find(params[:comment_id]) unless params[:comment_id].blank?
    
    (redirect_to(notices_url) and return) if @commentable.blank?
  end
end
