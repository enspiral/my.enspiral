class BadgesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @badges = Badge.order("created_at desc")
  end
  
  def new
    @badge = Badge.new
  end
  
  def edit
    @badge = Badge.find(params[:id])
  end

  def create
    @badge = Badge.new(params[:badge])
    @badge.created_by = current_user.id
    respond_to do |format|
      if @badge.save
        format.html { redirect_to(badges_path, :notice => 'Badge was successfully created.') }
        format.xml  { render :xml => @badge, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @badge = Badge.find(params[:id])

    respond_to do |format|
      if @badge.update_attributes(params[:badge])
        flash[:notice] = 'Badge was successfully updated.'
        format.html { redirect_to(badges_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @badge = Badge.find(params[:id])
    flash['notice'] = "Computer says no, the badge is probably assigned to someone or not created by you"
    redirect_to badges_path unless @badge.created_by == current_user.id || admin_user? || @badge.badge_ownership.nil?
  end
  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @badge = Badge.find(params[:id])

    @badge.destroy
    respond_to do |format|
      flash['notice'] = "The badge has been deleted"
      format.html { redirect_to(badges_url) }
      format.xml  { head :ok }
    end
  end


 

end
