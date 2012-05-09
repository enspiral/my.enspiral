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

    if @skill.save
      flash[:notice] = 'Skill was successfully created.'
      redirect_to admin_skills_url
    else
      render :action => "new" 
    end
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update_attributes(params[:skill])
      flash[:notice] = 'Skill was successfully updated.'
      redirect_to admin_skills_url
    else
      render :action => "edit" 
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    if @Skill.destroy
      flash[:notice] = 'Skill was successfully deleted.'
      redirect_to admin_skills_url
    else
      render :action => "edit" 
    end
  end
end
