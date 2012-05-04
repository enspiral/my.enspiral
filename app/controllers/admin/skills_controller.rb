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
        redirect_to(admin_skills_url, :notice => 'Skill was successfully created.') 
      else
        render :action => "new" 
      end
    end
  end

  def update
    @skill = Skill.find(params[:id])
    respond_to do |format|
      if @skill.update_attributes(params[:skill])
        redirect_to(admin_skills_url, :notice => 'Skill was successfully updated.') 
      else
        render :action => "edit" 
      end
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    redirect_to(admin_skills_url, :notice => "Skill was deleted successfully.") 
  end
end
