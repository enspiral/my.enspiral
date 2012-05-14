class FeaturedItemsController < IntranetController
  def index
    @featured_items = FeaturedItem.order('created_at DESC')
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
end
