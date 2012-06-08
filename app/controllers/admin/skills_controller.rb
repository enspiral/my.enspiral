class Admin::SkillsController < AdminController
  def index
    @skills = Skill.order('name')
  end

  def show
    @skill = Skill.find params[:id]
  end

  def new
    @skill = Skill.new
  end

  def edit
    @skill = Skill.find params[:id]
  end

  def create
    @skill = Skill.create params[:skill]

    if @skill.valid?
      flash[:notice] = 'Skill was successfully created.'
      redirect_to [:admin, :skills]
    else
      render :new
    end
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update_attributes(params[:skill])
      flash[:notice] = 'Skill was successfully updated.'
      redirect_to [:admin, @skill]
    else
      render :edit
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    if @skill.destroy
      flash[:notice] = 'Skill was successfully deleted.'
      redirect_to [:admin, :skills]
    else
      render :edit
    end
  end
end
