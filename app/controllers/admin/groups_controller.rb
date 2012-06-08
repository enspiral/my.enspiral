class Admin::GroupsController < AdminController
  def index
    @groups = Group.order('name')
  end

  def show
    @group = Group.find params[:id]
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.create(params[:group])

    if @group.valid?
      flash[:notice] = 'group was successfully created.'
      redirect_to [:admin, :groups]
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      flash[:notice] = 'group was successfully updated.'
      redirect_to [:admin, :groups]
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      flash[:notice] = 'group was successfully deleted.'
      redirect_to [:admin, :groups]
    else
      render :edit
    end
  end
end
