class FeaturedItemsController < IntranetController
  def index
    @featured_items = FeaturedItem.not_social.order('created_at DESC')
    @twitters = FeaturedItem.twitters
    @blogs = FeaturedItem.where(resource_type: 'Blog')
    @social_items = @twitters + @blogs
  end

  def show
    @featured_item = FeaturedItem.find(params[:id])
  end

  def edit
    @featured_item = FeaturedItem.find(params[:id])
  end

  def new
    @featured_item = FeaturedItem.new
  end

  def create
    @featured_item = FeaturedItem.new(params[:featured_item])
    if @featured_item.save
      flash[:success] = "Successfully created featured item"
      redirect_to featured_items_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @featured_item = FeaturedItem.find(params[:id])
    if @featured_item.destroy
      flash[:success] = "Successfully deleted featured item"
      redirect_to featured_items_url
    else
      flash[:error] = "Something annoying happened"
      redirect_to featured_items_url
    end

  end
end
