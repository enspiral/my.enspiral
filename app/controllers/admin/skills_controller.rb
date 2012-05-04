class Admin::SkillsController < AdminController
  def index
    @skills = Skill.order('description ASC')
  end

  def new
    @skill = Skill.new
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def create
    @skill = Skill.new(params[:skill])

    respond_to do |format|
      if @skill.save
        format.html { redirect_to(admin_skills_url, :notice => 'Skill was successfully created.') }
        format.xml  { render :xml => @skill, :status => :created, :location => @skill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @skill = Skill.find(params[:id])
    respond_to do |format|
      if @skill.update_attributes(params[:skill])
        format.html { redirect_to(admin_skills_url, :notice => 'Skill was successfully updated.') }
        format.xml  { render :xml => @skill, :status => :created, :location => @skill }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skill.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    respond_to do |format|
      format.html { redirect_to(admin_skills_url, :notice => "Skill was deleted successfully.") }
      format.xml  { head :ok }
    end
  end
end
