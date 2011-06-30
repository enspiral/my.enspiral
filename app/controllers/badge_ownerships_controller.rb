class BadgeOwnershipsController < ApplicationController
  layout 'intranet'
  #before_filter :authenticate_user!, :except => :show

  def index
    @badge_ownerships = BadgeOwnership.order("created_at desc")
  end

  def show
    @badge_ownership = BadgeOwnership.find(params[:id])
  end

  def new
    @badge_ownership = BadgeOwnership.new
  end

  def create
    @badge_ownership = BadgeOwnership.new(params[:badge_ownership])
    @badge_ownership.person = current_user.person
      respond_to do |format|
        if @badge_ownership.save
          format.html { redirect_to(badge_ownerships_path, :notice => 'Thanks!') }
          format.xml  { render :xml => @badge_ownership, :status => :created }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @badge_ownership.errors, :status => :unprocessable_entity }
        end
    end
  end

  def edit
    @badge_ownership = BadgeOwnership.find(params[:id])
    redirect_to badge_ownerships_path unless @badge_ownership.person == current_user.person || admin_user?
  end

  def update
    @badge_ownership = BadgeOwnership.find(params[:id])

    respond_to do |format|
      if @badge_ownership.update_attributes(params[:badge_ownership])
        flash[:notice] = 'Badge was successfully updated.'
        format.html { redirect_to(badge_ownerships_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @badge_ownership = BadgeOwnership.find(params[:id])
    redirect_to badge_ownerships_path unless @badge_ownership.person == current_user.person || admin_user?
  end
  def destroy
    @badge_ownership = BadgeOwnership.find(params[:id])
    @badge_ownership.destroy

    respond_to do |format|
      flash['notice'] = "The badge has been deleted"
      format.html { redirect_to(badge_ownerships_url) }
      format.xml  { head :ok }
    end
  end

end
