class Admin::GroupsController < AdminController
  def index
    @groups = Group.order('name ASC')
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      flash[:notice] = 'group was successfully created.'
      redirect_to admin_groups_url
    else
      render :action => "new" 
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      flash[:notice] = 'group was successfully updated.'
      redirect_to admin_groups_url
    else
      render :action => "edit" 
    end
  end

  def destroy
    @group = Group.find(params[:id])
    if @group.destroy
      flash[:notice] = 'group was successfully deleted.'
      redirect_to admin_groups_url
    else
      render :action => "edit"
    end
  end
end
