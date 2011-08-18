class GoalsController < ApplicationController
  layout 'intranet'
  #before_filter :authenticate_user!, :except => :show

  def index
    @current = Goal.where("date >= ?", Time.now)
    @past = Goal.where("date <= ?", Time.now)
    @goal = Goal.new
  end
  
  def new
    @goal = Goal.new
  end
  
  def edit
    @goal = Goal.find(params[:id])
  end

  def create
    @goal = Goal.new(params[:goal])
    @goal.person_id = current_user.person.id
    respond_to do |format|
      if @goal.save
        format.html { redirect_to(goals_path, :notice => 'Goal was successfully created.') }
        format.xml  { render :xml => @goal, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @goal = Goal.find(params[:id])

    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        flash[:notice] = 'Goal was successfully updated.'
        format.html { redirect_to(goals_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def delete
    @goal = Goal.find(params[:id])
    flash['notice'] = "Computer says no, the goal is probably assigned to someone or not created by you"
    redirect_to goals_path unless @goal.created_by == current_user.id || admin_user? || @goal.goal_ownership.nil?
  end
  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @goal = Goal.find(params[:id])

    @goal.destroy
    respond_to do |format|
      flash['notice'] = "The goal has been deleted"
      format.html { redirect_to(goals_url) }
      format.xml  { head :ok }
    end
  end

end
